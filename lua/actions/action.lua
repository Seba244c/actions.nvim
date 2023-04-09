-- create a global bufnr
Actions_bufnr = vim.api.nvim_create_buf(false, true)
Actions_initialized = false

-- Creates an object for the module.
local M = {}
local utils = require("actions.utils")

local function init()
    --Get the current UI
    ui = vim.api.nvim_list_uis()[1]

    local width = utils.round(ui.width * 0.5)
    local height = utils.round(ui.height * 0.5)

    Actions_initialized = true
    vim.api.nvim_open_win(Actions_bufnr, true, utils.window_config(width, height))
    open_file_cmd = "e " .. utils.actions_file_path()
    vim.api.nvim_command(open_file_cmd)
    vim.api.nvim_command("startinsert")

    vim.keymap.set("n", "<CR>", M.action, { buffer = Actions_bufnr })
    vim.keymap.set("i", "<CR>", M.action, { buffer = Actions_bufnr })
end

function M.cmd(cmd)
    vim.api.nvim_command("stopinsert")
    local Terminal = require('toggleterm.terminal').Terminal
    local term = Terminal:new({
        cmd = cmd,
        hidden = true,
        close_on_exit = true,
    })
    term:toggle();
    term:focus();
end

function M.action()
    -- Make sure actions file exist
    utils.check_file()

    -- Now open the file
    -- override ui every time toggle is called
    ui = vim.api.nvim_list_uis()[1]
    local buf_hidden = 0
    local buf_info = vim.api.nvim_call_function('getbufinfo', { utils.actions_file_path() })[1]

    -- Check if file is hidden
    if buf_info then
        buf_hidden = buf_info.hidden
    end

    local current_bufnr = vim.api.nvim_win_get_buf(0)
    if not Actions_initialized then
        init()
    elseif current_bufnr == Actions_bufnr then
        -- Close and clean file, and get the action
        local action = vim.fn.getbufoneline(Actions_bufnr, 1)
        vim.api.nvim_buf_set_lines(Actions_bufnr, 0, 1, false, { "" })
        vim.api.nvim_command("w")

        -- Parse Actions
        local actions = vim.fn.json_decode(vim.fn.getbufline(Actions_bufnr, 5))
        local action = actions[action]
        utils.hide()

        -- Handle action
        -- Checks
        if not action.name then
            print("action.name must be string")
            return
        end

        -- Handle Action
        if action.type == "cmd" then
            M.cmd(action.cmd)
        else
            print('action.type must be "cmd"')
        end
    elseif buf_hidden == 0 and buf_info.windows[1] then
        vim.api.nvim_set_current_win(buf_info.windows[1])
        vim.api.nvim_command("startinsert")
    else
        utils.show_buffer(Actions_bufnr, M.action)
        vim.api.nvim_command("startinsert")
    end
end

return M
