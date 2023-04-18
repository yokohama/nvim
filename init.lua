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

  use 'windwp/nvim-ts-autotag'
  use 'windwp/nvim-autopairs'

  use 'akinsho/nvim-bufferline.lua'

  use 'glepnir/lspsaga.nvim'
end)

-- Set the leader key to Space
vim.g.mapleader = ','

-- ソースコード全体を選択し、クリップボードにコピーするキーマップ
vim.api.nvim_set_keymap('n', '<leader>yc', 'ggVG"+y', {noremap = true, silent = true})

vim.opt.number = true
--vim.opt.termguicolors = true
vim.opt.winblend = 30
vim.opt.pumblend = 80
vim.opt.cursorline = true

-- Load Plugins
require('plugin-settings/color')
require('plugin-settings/nvim-tree')
require('plugin-settings/nvim-lualine')
require('plugin-settings/lsp')
require('plugin-settings/mason')
require('plugin-settings/cmp')
require('plugin-settings/nvim-treesitter')
require('plugin-settings/auto-tag-pairs')
require('plugin-settings/nvim-bufferline')
require('plugin-settings/lspsaga')
