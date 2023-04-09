" Title:        Actions
" Description:  A plugin that makes it easy to configure actions to run from
" your ide
" Last Change:  9 April 2023
" Maintainer:   Sebastian Snoer <https://github.com/Seba244c>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_actionsplugin")
    finish
endif
let g:loaded_actionsplugin = 1

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 Action lua require("actions").action()


" Disable highlighting for floating window
hi NormalFloat guibg=none guifg=none
