--
-- # よく使うショートカット
-- 1. github        : , + lg
-- 2. LSP(明表示)   : , + gp
-- 3. 全文コピー    : , + yc
-- 4. 行数指定コピー: , + 10 + y
-- 5. nvintree      : ,n
--

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

  -- プログラミング、ナビゲーター
  use "lukas-reineke/indent-blankline.nvim"
  --use 'github/copilot.vim'

  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/vim-vsnip"
  --use 'nvim-treesitter/nvim-treesitter' 上記の組合せで十分


  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}

  -- 使いたいが上記LSPと入れると動かなくなるのでコメント
  -- use {
  --  "windwp/nvim-autopairs",
  --   event = "InsertEnter",
  --  config = function()
  --    require("nvim-autopairs").setup {}
  --  end
  --}
end)

-- Set the leader key to Space
vim.g.mapleader = ','

-- クリップボード
vim.opt.clipboard = "unnamedplus"

-- , + yc で、全テキストをクリップボードにコピーする
vim.api.nvim_set_keymap('n', '<leader>yc', 'ggVG"+y', {noremap = true, silent = true})

vim.opt.number = true
vim.opt.winblend = 30
vim.opt.pumblend = 80
vim.opt.cursorline = true

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
augroup END
]]

vim.g.python3_host_prog = "$HOME/home/banister/.pyenv/shims/python"

-- Load Plugins
require('plugin-settings/nvim-tree')
require('plugin-settings/tggleterm')
require('plugin-settings/indent-blankline')
require('plugin-settings/nvim-lualine')
require('plugin-settings/mason')
require('plugin-settings/cmp')
require('plugin-settings/lsp')
