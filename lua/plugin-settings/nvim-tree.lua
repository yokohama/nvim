vim.opt.termguicolors = true

require("nvim-tree").setup({
  view = {
    width = 20,
  },
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

vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', {noremap = true, silent = true})

-- ウィンドウが2以下（NvimTreeとエディタ1つの場合）の時のみ NvimTree を閉じる
vim.cmd([[
  function! ConditionalNvimTreeClose()
    if winnr('$') <= 2
      if winnr('$') == 1 && &ft == 'NvimTree'
        quit
      elseif winnr('$') == 2 && &ft != 'NvimTree'
        NvimTreeClose
      endif
    endif
  endfunction

  autocmd QuitPre * call ConditionalNvimTreeClose()
]])
