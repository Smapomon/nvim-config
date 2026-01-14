---@diagnostic disable: undefined-global

local function gen_ids(opts)
  local start_letter = string.byte(opts.fargs[1] or "A")
  local end_letter   = string.byte(opts.fargs[2] or "J")
  local start_num    = tonumber(opts.fargs[3]) or 1
  local end_num      = tonumber(opts.fargs[4]) or 9999

  local out = {}

  for c = start_letter, end_letter do
    local letter = string.char(c)
    for n = start_num, end_num do
      out[#out + 1] = string.format("%s%04d", letter, n)
    end
  end

  vim.api.nvim_put(out, "l", true, true)
end

vim.api.nvim_create_user_command("GenIds", gen_ids, { nargs = "*" })
