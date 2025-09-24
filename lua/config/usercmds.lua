---@diagnostic disable: undefined-global

vim.api.nvim_create_user_command(
  'Cclear',
  "cexpr []",
  {bang = true}
)

vim.api.nvim_create_user_command(
  'FormatJson',
  "%!jq .",
  {bang = false}
)

vim.api.nvim_create_user_command(
  'FormatSql',
  "%!sqlformat --reindent --keywords upper --identifiers lower -",
  {bang = false}
)

vim.api.nvim_create_user_command(
  'CloseBufsExceptCurrent',
  "%bd|e#|bd#",
  {bang = false}
)

vim.api.nvim_create_user_command(
  'CloseBufInsideWindow',
  "bp | sp | bn | bd",
  {bang = false}
)

vim.api.nvim_create_user_command(
  'CopyFileName',
  [[:let @+ = expand("%")]],
  {bang = false}
)

vim.api.nvim_create_user_command(
  'CopyFilePath',
  [[:let @+ = expand("%:p")]],
  {bang = false}
)

