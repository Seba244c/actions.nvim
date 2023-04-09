function remove_empty_line(string)
    return vim.api.nvim_call_function('split', { string, '\n' })[1]
end

local utils = {}
local actions_file_path = "./.actions"

function utils.actions_file_path()
    return actions_file_path
end

function utils.round(float)
  return math.floor(float + .5)
end


function utils.window_config(width, height)
  if vim.api.nvim_call_function('has', {'nvim-0.5.0'}) == 1 then
    local border = vim.g.workbench_border or "double"

    return {
      relative = "editor",
      width = width,
      height = height,
      col = (ui.width - width) / 2,
      row = (ui.height - height) / 2,
      style = 'minimal',
      focusable = false,
      border = border
    }
  else
    return {
      relative = "editor",
      width = width,
      height = height,
      col = (ui.width - width) / 2,
      row = (ui.height - height) / 2,
      style = 'minimal',
      focusable = false,
    }
  end
end

function utils.check_file()
    if vim.fn.filereadable(vim.fn.expand(actions_file_path)) == 0 then
        vim.fn.writefile({
            "",
            "# Type the action id above and press <CR>, to run an the action",
            "# Do not change the content of line 2, 3 & 4 of this file",
            "# Actions are written as JSON below",
            "{}",
        }, actions_file_path)
    end
end

function utils.hide()
  vim.api.nvim_command('close')
end

function utils.show_buffer(bufnr)
  local width = utils.round(ui.width * 0.5)
  local height = utils.round(ui.height * 0.5)

  vim.api.nvim_open_win(bufnr, true, utils.window_config(width, height))
end

function utils.is_git_repo()
    local bool = vim.api.nvim_eval('system("git rev-parse --is-inside-work-tree")')
    local parsed_bool = remove_empty_line(bool)
    return parsed_bool
end

return utils
