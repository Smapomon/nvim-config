-- Entrypoint for modules
require('smapo.plugins')
require('smapo.settings')
require('smapo.plug_confs')
require('smapo.autocmd')
require('smapo.keybinds')

-- lua table pretty print
function _G.dump(...)
	local objects vim.tbl_map(vim.inspect, { ... })
	print(unpack(objects))
end
