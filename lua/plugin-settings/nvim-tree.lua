--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
  --auto_close = true,
  --gitignore = false,
  update_focused_file = {
    enable = true
  },
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeToggle<CR>', {noremap = true, silent = true})

-- Lenovo
vim.api.nvim_set_keymap('n', '<M-h>', ':wincmd h<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<M-l>', ':wincmd l<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<M-j>', ':wincmd j<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<M-k>', ':wincmd k<CR>', {noremap = true, silent = true})

-- HappyHacking
-- vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', {noremap = true, silent = true})


-- vim.cmd [[autocmd VimEnter * NvimTreeOpen]]
