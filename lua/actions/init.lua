-- Imports the plugin's additional Lua modules.
local action = require("actions.action")

-- Creates an object for the module. All of the module's
-- functions are associated with this object, which is
-- returned when the module is called with `require`.
local M = {}

function M.bind(mode, key)
    vim.keymap.set(mode, key, action.action)
end

-- Routes calls made to this module to functions in the
-- plugin's other modules.
M.action = action.action

return M
