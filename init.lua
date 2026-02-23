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

-- 独自機能
-- require("yokohama.preview-diagram-kitty")
require("yokohama.mark-text-exe")
require("yokohama.img-paste")
require("yokohama.pentest-memo").setup()
require("yokohama.shortcut-help").setup()
require("yokohama.md").setup()

-- アクティブ/非アクティブ window 背景色制御
local function set_window_background()
  -- アクティブ window（赤系）
  -- bg = "#2e1f1f",
  vim.api.nvim_set_hl(0, "Normal", {
    bg = "NONE",
    -- bg = "#2e1f1f",
  })

  -- 非アクティブ
  -- bg = "#141617",
  vim.api.nvim_set_hl(0, "NormalNC", {
    bg = "NONE",
  })

  -- NvimTree 専用背景
  -- bg = "#1f2a24",
  -- bg = "#24362c",
  vim.api.nvim_set_hl(0, "NvimTreeNormal", {
    bg = "NONE",
  })

  -- ウィンドウ間のセパレーター/境界線を透明に
  vim.api.nvim_set_hl(0, "WinSeparator", {
    bg = "NONE",
  })
  vim.api.nvim_set_hl(0, "VertSplit", {
    bg = "NONE",
  })
  vim.api.nvim_set_hl(0, "FloatBorder", {
    bg = "NONE",
  })

  -- フローティングウィンドウ（avante等）を透明に
  vim.api.nvim_set_hl(0, "NormalFloat", {
    bg = "NONE",
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

-- Avante のペインも透明にする
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Avante", "AvanteInput", "AvanteSelectedFiles" },
  callback = function()
    vim.api.nvim_win_set_option(
      0,
      "winhighlight",
      "Normal:Normal,NormalNC:NormalNC"
    )
  end,
})
