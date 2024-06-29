--[[
# よく使うショートカット
1. github                          : , + lg
2. LSP(表示)                       : , + gp
3. 全文コピー                      : , + yc
4. 行数指定コピー                  : , + 10 + y
5. nvintree                        : ,n
6. cmpによるレコメンドリストの移動 : C-[j k]
7. 横に画面分割                    : :new
8. 縦に画面分割                    : :vnew
9. 分割した画面の移動              : C-[h j k l]
0. cargo watch                     : WatchCargo
1. クリップボードの貼り付け        : C-V
]]

-- Undefined global `vim`.のワーニングのやっつけ対策
_G.vim = vim or {}

local status, packer = pcall(require, 'packer')

if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  -- パッケージ管理
  use 'wbthomason/packer.nvim'

  -- ファイラー、ナビゲーター
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use 'nvim-lualine/lualine.nvim'

  -- カラー
  --use 'svrana/neosolarized.nvim'
  --use 'tjdevries/colorbuddy.nvim'
  use 'morhetz/gruvbox'
  vim.cmd [[colorscheme gruvbox]]

  -- プログラミング、ナビゲーター
  use "lukas-reineke/indent-blankline.nvim"
  --use 'github/copilot.vim'

  -- LSP
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/vim-vsnip"
  --use 'nvim-treesitter/nvim-treesitter' 上記の組合せで十分

  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}
end)

-- Set the leader key to Space
vim.g.mapleader = ','

-- クリップボード
vim.opt.clipboard = "unnamedplus"

-- , + yc で、全テキストをクリップボードにコピーする
vim.api.nvim_set_keymap('n', '<leader>yc', 'ggVG"+y', {noremap = true, silent = true})

-- インデント
vim.cmd [[
  augroup MyAutoCmd
  autocmd!
  autocmd FileType go         setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType html       setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType ruby       setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType python     setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType lua        setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType json       setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType c          setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType cpp        setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType rust       setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType asm        setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup END
]]

vim.g.python3_host_prog = "$HOME/.pyenv/shims/python"

-- 背景透明　
--vim.cmd [[colorscheme desert]]
vim.cmd [[highlight Normal ctermbg=NONE guibg=NONE]]

-- Load Plugins
require('plugin-settings/nvim-tree')
require('plugin-settings/tggleterm')
require('plugin-settings/indent-blankline')
require('plugin-settings/nvim-lualine')
require('plugin-settings/mason')
require('plugin-settings/lsp')
require('plugin-settings/terminal')
require('plugin-settings/dev-watch')
