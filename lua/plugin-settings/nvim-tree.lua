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

local hostname = vim.fn.system('hostname'):gsub("\n", "")

-- Happy hacking!
if hostname == "sun" then
  vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', {noremap = true, silent = true})
-- Thinkpad
elseif hostname == "thinkpad" then
  vim.api.nvim_set_keymap('n', 'H', ':wincmd h<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', 'L', ':wincmd l<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', 'J', ':wincmd j<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', 'K', ':wincmd k<CR>', {noremap = true, silent = true})
end

-- vim.cmd [[autocmd VimEnter * NvimTreeOpen]]
