return {
  -- Mason: パッケージマネージャー
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "BufReadPre",
    config = function()
      require('mason').setup()
    end
  },

  -- Mason-lspconfig: MasonとLSPの連携
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = "BufReadPre",
    config = function()
      -- React Native開発に必要なLSPサーバーを設定
      require('mason-lspconfig').setup({
        ensure_installed = {
          "tsserver",           -- TypeScript/JavaScript
          "eslint",             -- ESLint
          "tailwindcss",        -- Tailwind CSS
          "cssls",              -- CSS
          "jsonls",             -- JSON
        }
      })

      require('mason-lspconfig').setup_handlers({ function(server)
        local opt = {
          capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
        }

        -- pylspの特別な設定
        if server == 'pylsp' then
          opt.settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  ignore = {'E111'},
                }
              }
            }
          }
        end

        -- tsserverの特別な設定
        if server == 'tsserver' then
          opt.settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          }
        end

        -- eslintの特別な設定
        if server == 'eslint' then
          opt.settings = {
            packageManager = 'npm',
            format = { enable = true },
            codeActionOnSave = { enable = true, mode = "all" },
            workingDirectories = { mode = "auto" },
          }
        end

        require('lspconfig')[server].setup(opt)
      end })

      -- solargraphの明示的な設定
      require('lspconfig').solargraph.setup {}
    end
  },

  -- nvim-lspconfig: LSPの設定
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- LSPのキーマッピング
      vim.keymap.set('n', 'gp', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})

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
      _G.UpdateDiagnosticsAndStay = function()
        local current_win = vim.api.nvim_get_current_win()
        vim.diagnostic.setloclist({open_loclist = false})
        vim.api.nvim_set_current_win(current_win)
      end

      -- vim終了時にロケーションリストも閉じる
      vim.cmd([[
        autocmd QuitPre * lclose
      ]])
    end
  },

  -- cmp-nvim-lsp: LSP補完のためのソース
  {
    "hrsh7th/cmp-nvim-lsp",
    event = "InsertEnter",
  },

  -- vim-vsnip: スニペットエンジン
  {
    "hrsh7th/vim-vsnip",
    event = "InsertEnter",
  },

  -- nvim-cmp: 補完エンジン
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/vim-vsnip",
    },
    config = function()
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
    end
  },
}
