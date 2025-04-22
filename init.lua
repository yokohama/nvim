-- Undefined global `vim`.のワーニングのやっつけ対策
_G.vim = vim or {}

-- Set the leader key to Space (早めに設定)
vim.g.mapleader = ','

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグイン設定を読み込む
require("lazy").setup({
  { import = "plugins" },
})

-- 基本設定を読み込む
require("core.options")    -- 基本的なVimオプション
require("core.ui")         -- UI関連の設定
require("core.clipboard")  -- クリップボード関連の設定
require("core.indent")     -- インデント関連の設定
require("core.keymaps")    -- キーマッピング
require("core.terminal")   -- ターミナル関連の設定
