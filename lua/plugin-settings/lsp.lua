vim.keymap.set('n', 'gp',  '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})

-- Floatウィンドウの背景色を変更
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e0a33" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e0a33", fg = "#ffffff" })

-- LSPのホバー表示をカスタマイズ
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- you can choose in "single", "double", "rounded", "solid", "shadow"
    border = "rounded"
  }
)

-- LSP 設定
require('lspconfig')['pylsp'].setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'E111'},
        }
      }
    }
  }
}

-- nvim-cmp 設定
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
  experimental = {
    ghost_text = true,
  },
  window = {
    completion = cmp.config.window.bordered(),
  }
})

-- クイックリストの設定
vim.diagnostic.config({
  virtual_text = false,  -- ソースコード上に直接表示しない
  signs = true,          -- サインカラムに警告やエラーのアイコンを表示
  underline = true,      -- 警告やエラーのテキストを下線で表示
  update_in_insert = false,  -- インサートモード中に診断を更新しない
  severity_sort = true,  -- 重要度によってソート
})

vim.cmd([[
  autocmd BufWritePost,InsertLeave,CursorHold * lua UpdateDiagnosticsAndStay()
]])

-- 診断を更新しつつカーソルをエディタに留める関数
function UpdateDiagnosticsAndStay()
  local current_win = vim.api.nvim_get_current_win()
  vim.diagnostic.setloclist({open_loclist = false})
  vim.api.nvim_set_current_win(current_win)
end

-- vim終了時にロケーションリストも閉じる
vim.cmd([[
  autocmd QuitPre * lclose
]])
