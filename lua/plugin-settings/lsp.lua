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
