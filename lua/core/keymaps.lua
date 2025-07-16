-- キーマッピング設定

-- NvimTree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- ウィンドウ移動
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<CR>', { noremap = true, silent = true })

-- ToggleTerm
vim.keymap.set('n', '<leader>t', ':Toggle<CR>', { noremap = true, silent = true, desc = "Toggle Terminal" })

-- Diagram.nvim は自動でレンダリングするため、手動コマンドは不要
