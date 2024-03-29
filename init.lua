local status, packer = pcall(require, 'packer')

if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'nvim-tree/nvim-web-devicons' 
  use 'tjdevries/colorbuddy.nvim'
  use 'svrana/neosolarized.nvim'

  use 'nvim-lualine/lualine.nvim'

  use 'nvim-tree/nvim-tree.lua'
  use 'neovim/nvim-lspconfig' 
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  use 'onsails/lspkind-nvim'
  use 'L3MON4D3/LuaSnip'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'

  use 'nvim-treesitter/nvim-treesitter'
  use 'tpope/vim-endwise'

  use 'windwp/nvim-ts-autotag'
  use 'windwp/nvim-autopairs'

  use 'akinsho/nvim-bufferline.lua'

  use 'glepnir/lspsaga.nvim'

  --use 'akinsho/toggleterm.nvim'
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}

  use "lukas-reineke/indent-blankline.nvim"

  --use 'jose-elias-alvarez/null-ls.nvim'

  use 'github/copilot.vim'

  use 'maxmellon/vim-jsx-pretty'
end)

-- Set the leader key to Space
vim.g.mapleader = ','

-- クリップボード
vim.opt.clipboard:append{'unnamedplus'}

-- ソースコード全体を選択し、クリップボードにコピーするキーマップ
vim.api.nvim_set_keymap('n', '<leader>yc', 'ggVG"+y', {noremap = true, silent = true})

vim.opt.number = true
--vim.opt.termguicolors = true
vim.opt.winblend = 30
vim.opt.pumblend = 80
vim.opt.cursorline = true

-- インデント
vim.cmd [[
  augroup MyAutoCmd
  autocmd!
  autocmd FileType python     setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType go         setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
  autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType html       setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType ruby       setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType lua        setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType json       setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType c          setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END
]]

-- Load Plugins
-- ダメ require('plugin-settings/auto-tag-pairs')
-- 元からコメント require('plugin-settings/null-ls')
require('plugin-settings/color')
require("plugin-settings/nvim-web-devicons")
require('plugin-settings/nvim-tree')
require('plugin-settings/nvim-lualine')
require('plugin-settings/lsp')
require('plugin-settings/mason')
require('plugin-settings/cmp') 
require('plugin-settings/nvim-bufferline')
require('plugin-settings/lspsaga')
require('plugin-settings/tggleterm') 
require('plugin-settings/indent-blankline') 
require('plugin-settings/nvim-treesitter')
