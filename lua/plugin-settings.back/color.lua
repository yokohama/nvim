vim.opt.termguicolors = true

vim.cmd('autocmd ColorScheme * highlight Pmenu guibg=#3a3a3a guifg=#ffffff blend=50')
vim.cmd('autocmd ColorScheme * highlight PmenuSel guibg=#4a4a4a guifg=#ffffff blend=30')

local neosolarized = require('neosolarized')
neosolarized.setup({
  comment_italics = true,
})

vim.cmd('colorscheme neosolarized')
