-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local key_map_opts = { noremap=true, silent=true }
local editor = vim;
local navic = require('nvim-navic')

navic.setup {
  icons = {
    File          = "󰈙 ",
    Module        = " ",
    Namespace     = "󰌗 ",
    Package       = " ",
    Class         = "󰌗 ",
    Method        = "󰆧 ",
    Property      = " ",
    Field         = " ",
    Constructor   = " ",
    Enum          = "󰕘",
    Interface     = "󰕘",
    Function      = "󰊕 ",
    Variable      = "󰆧 ",
    Constant      = "󰏿 ",
    String        = "󰀬 ",
    Number        = "󰎠 ",
    Boolean       = "◩ ",
    Array         = "󰅪 ",
    Object        = "󰅩 ",
    Key           = "󰌋 ",
    Null          = "󰟢 ",
    EnumMember    = " ",
    Struct        = "󰌗 ",
    Event         = " ",
    Operator      = "󰆕 ",
    TypeParameter = "󰊄 ",
  },
  highlight = true,
  separator = ' -> ',
}

editor.api.nvim_set_hl(0, "NavicIconsFile",          {default = true, bg = "#000000", fg = "#33b5c6"})
editor.api.nvim_set_hl(0, "NavicIconsModule",        {default = true, bg = "#000000", fg = "#4933c6"})
editor.api.nvim_set_hl(0, "NavicIconsNamespace",     {default = true, bg = "#000000", fg = "#c6334c"})
editor.api.nvim_set_hl(0, "NavicIconsPackage",       {default = true, bg = "#000000", fg = "#c6bf33"})
editor.api.nvim_set_hl(0, "NavicIconsClass",         {default = true, bg = "#000000", fg = "#36c633"})
editor.api.nvim_set_hl(0, "NavicIconsMethod",        {default = true, bg = "#000000", fg = "#3389c6"})
editor.api.nvim_set_hl(0, "NavicIconsProperty",      {default = true, bg = "#000000", fg = "#c63373"})
editor.api.nvim_set_hl(0, "NavicIconsField",         {default = true, bg = "#000000", fg = "#c633bd"})
editor.api.nvim_set_hl(0, "NavicIconsConstructor",   {default = true, bg = "#000000", fg = "#33c6b5"})
editor.api.nvim_set_hl(0, "NavicIconsEnum",          {default = true, bg = "#000000", fg = "#98c633"})
editor.api.nvim_set_hl(0, "NavicIconsInterface",     {default = true, bg = "#000000", fg = "#98c633"})
editor.api.nvim_set_hl(0, "NavicIconsFunction",      {default = true, bg = "#000000", fg = "#c68933"})
editor.api.nvim_set_hl(0, "NavicIconsVariable",      {default = true, bg = "#000000", fg = "#c633b0"})
editor.api.nvim_set_hl(0, "NavicIconsConstant",      {default = true, bg = "#000000", fg = "#9f33c6"})
editor.api.nvim_set_hl(0, "NavicIconsString",        {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsNumber",        {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsBoolean",       {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsArray",         {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsObject",        {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsKey",           {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsNull",          {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsEnumMember",    {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsStruct",        {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsEvent",         {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsOperator",      {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicIconsTypeParameter", {default = true, bg = "#000000", fg = "#b333c6"})
editor.api.nvim_set_hl(0, "NavicText",               {default = true, bg = "#000000", fg = "#333333"})
editor.api.nvim_set_hl(0, "NavicSeparator",          {default = true, bg = "#000000", fg = "#a87e43"})


editor.keymap.set('n', '<Leader>e', editor.diagnostic.open_float, key_map_opts)
editor.keymap.set('n', 'gp', editor.diagnostic.goto_prev, key_map_opts)
editor.keymap.set('n', 'gn', editor.diagnostic.goto_next, key_map_opts)
editor.keymap.set('n', '<Leader>q', editor.diagnostic.setloclist, key_map_opts)

editor.o.updatetime = 300 -- updatetime affects the CursorHold event

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  editor.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  editor.keymap.set('n', 'gD', editor.lsp.buf.declaration, bufopts)
  editor.keymap.set('n', '<Leader>gd', editor.lsp.buf.definition, bufopts)
  editor.keymap.set('n', 'gd', function()
    require("fzf-lua").lsp_definitions{}
  end, bufopts)
  editor.keymap.set('n', 'K', editor.lsp.buf.hover, bufopts)
  editor.keymap.set('n', 'gi', editor.lsp.buf.implementation, bufopts)
  editor.keymap.set('n', 'gk', editor.lsp.buf.signature_help, bufopts)
  editor.keymap.set('n', '<Leader>wa', editor.lsp.buf.add_workspace_folder, bufopts)
  editor.keymap.set('n', '<Leader>wr', editor.lsp.buf.remove_workspace_folder, bufopts)
  editor.keymap.set('n', '<Leader>wl', function()
    print(editor.inspect(editor.lsp.buf.list_workspace_folders()))
  end, bufopts)
  editor.keymap.set('n', '<Leader>td', editor.lsp.buf.type_definition, bufopts)
  editor.keymap.set('n', '<Leader>r', editor.lsp.buf.rename, bufopts)
  editor.keymap.set('n', '<Leader>ca', editor.lsp.buf.code_action, bufopts)
  editor.keymap.set('n', 'gr', editor.lsp.buf.references, bufopts)
  editor.keymap.set('n', '<space>f', function() editor.lsp.buf.format { async = true } end, bufopts)

  -- Visual options
  local err_sev = editor.diagnostic.severity
  editor.diagnostic.config({
    virtual_text = false,
    signs = {
      text = { [err_sev.ERROR] = "⛔", [err_sev.WARN] = "⚠️", [err_sev.HINT] = "💡", [err_sev.INFO] = "🔎" }
    },
    update_in_insert = true,
    float = {
      source = "always",
    },
    severity_sort = true,
  })

  editor.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local diag_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        source = 'always',
        prefix = '🔎 ',
      }

      editor.diagnostic.open_float(nil, diag_opts)
    end
  })
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require("mason").setup()
require("mason-lspconfig").setup()

-- Setup lsp default servers
local servers = { 'solargraph', 'kotlin_language_server', 'gopls', 'templ', 'ts_ls', 'rust_analyzer', 'lua_ls', 'clangd', 'yamlls', 'terraformls', 'slint_lsp', 'dartls' }
for _, lsp in ipairs(servers) do
  if lsp == 'gopls' then
    require('lspconfig')[lsp].setup{
      capabilities = Capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
      cmd = { 'gopls'},
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_dir = require('lspconfig/util').root_pattern('go.work', 'go.mod', '.git'),
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        }
      }
    }
  else
    require('lspconfig')[lsp].setup{
      capabilities = Capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
    }
  end
end

-- Format mappings
editor.keymap.set({'n', 'v'}, 'gf', function()
  editor.lsp.buf.format()
end)

-- ########################## --
-- ###### LSP MESSAGES ###### --
-- ########################## --

local client_notifs = {}

local function get_notif_data(client_id, token)
  if not client_notifs[client_id] then
    client_notifs[client_id] = {}
  end

  if not client_notifs[client_id][token] then
    client_notifs[client_id][token] = {}
  end

  return client_notifs[client_id][token]
end

local function format_title(title, client_name)
  if not title then
    title = ""
  else
    title = " " .. title
  end

  return "LSP -- " .. client_name .. title .. ": "
end

local function format_message(message, percentage)
  return (percentage and percentage .. "%\t" or "") .. (message or "")
end

editor.lsp.handlers["$/progress"] = function(_, result, ctx)
  local client_id = ctx.client_id
  local val       = result.value

  if not val.kind then
    return
  end

  local notif_data    = get_notif_data(client_id, result.token)
  local title         = format_title(val.title, editor.lsp.get_client_by_id(client_id).name)
  local message       = ""
  local print_message = ""

  if val.percentage == 0 then
    return
  end

  if val.kind == "begin" then
    message = format_message(val.message, val.percentage)
  elseif val.kind == "report" and notif_data then
    message = format_message(val.message, val.percentage)
  elseif val.kind == "end" and notif_data then
    if not val.message then
      message = "Complete"
    else
      message = format_message(val.message)
    end
  end

  if message == 'done' then
    return
  end

  print_message = title .. message
  print(print_message)
end

