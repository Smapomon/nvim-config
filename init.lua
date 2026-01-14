-- Entrypoint for modules
require("config.opts")
require("config.lazy")
require("lazy").setup("plugins")

require("config.keybinds")
require("config.autocmds")
require("config.usercmds")
require("config.util_commands")
