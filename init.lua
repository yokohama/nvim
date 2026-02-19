-- Undefined global `vim`. のワーニング回避（LSP / LuaLS 用）
_G.vim = vim or {}

-- Leader key
vim.g.mapleader = ','

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグイン設定
require("lazy").setup("plugins", {
  rocks = {
    enabled = false,
  },
})

-- 基本設定
require("core.options")
require("core.ui")
require("core.clipboard")
require("core.indent")
require("core.keymaps")
require("core.terminal")
require("core.pentest")

-- Kali Linux 判定
local function is_kali_linux()
  local handle = io.popen("uname -a")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("kali") ~= nil
  end
  return false
end

if is_kali_linux() then
  require("core.kali_specific").setup()
end

-- 独自機能
-- require("yokohama.preview-diagram-kitty")
require("yokohama.preview-diagram-wsl")
require("yokohama.img-paste")

-- アクティブ/非アクティブ window 背景色制御
local function set_window_background()
  -- アクティブ window（赤系）
  vim.api.nvim_set_hl(0, "Normal", {
    bg = "#2e1f1f",
  })

  -- 非アクティブ
  vim.api.nvim_set_hl(0, "NormalNC", {
    bg = "#141617",
  })

  -- NvimTree 専用背景
  vim.api.nvim_set_hl(0, "NvimTreeNormal", {
    --bg = "#1f2a24",
    bg = "#24362c",
  })
end

-- 起動直後にも適用
set_window_background()

-- colorscheme 変更時にも再適用
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_window_background,
})

-- NvimTree は winhighlight で Normal から切り離す
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.api.nvim_win_set_option(
      0,
      "winhighlight",
      "Normal:NvimTreeNormal,NormalNC:NvimTreeNormal"
    )
  end,
})
