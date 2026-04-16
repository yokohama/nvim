return {
  {
    "williamboman/mason.nvim",
    opts = {},
    event = "BufReadPre",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = "BufReadPre",
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { "ts_ls", "eslint", "tailwindcss", "cssls", "jsonls", "pylsp", "solargraph", "rust_analyzer" },
        automatic_installation = false,
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    event = "BufReadPre",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- TypeScript/JavaScript
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            }
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
            }
          }
        }
      })

      -- ESLint
      vim.lsp.config('eslint', {
        capabilities = capabilities,
        settings = {
          codeAction = {
            disableRuleComment = { enable = true, location = "separateLine" },
            showDocumentation = { enable = true }
          },
          codeActionOnSave = { enable = false, mode = "all" },
          experimental = { useFlatConfig = false },
          format = true,
          nodePath = "",
          onIgnoredFiles = "off",
          problems = { shortenToSingleLine = false },
          quiet = false,
          rulesCustomizations = {},
          run = "onType",
          useESLintClass = false,
          validate = "on",
          workingDirectory = { mode = "location" }
        }
      })

      -- Tailwind CSS
      vim.lsp.config('tailwindcss', { capabilities = capabilities })

      -- CSS
      vim.lsp.config('cssls', { capabilities = capabilities })

      -- JSON
      vim.lsp.config('jsonls', { capabilities = capabilities })

      -- Python
      vim.lsp.config('pylsp', {
        capabilities = capabilities,
        settings = { pylsp = { plugins = { pycodestyle = { ignore = {'E111'} } } } }
      })

      -- Ruby
      vim.lsp.config('solargraph', { capabilities = capabilities })

      -- Dart (Flutter)
      vim.lsp.config('dartls', {
        cmd = { '/usr/lib/dart-sdk/bin/dart', 'language-server', '--protocol=lsp' },
        filetypes = { 'dart' },
        root_markers = { 'pubspec.yaml' },
        capabilities = capabilities,
        settings = {
          dart = {
            completeFunctionCalls = true,
            showTodos = true,
          }
        }
      })

      -- Rust
      vim.lsp.config('rust_analyzer', {
        cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/rust-analyzer') },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json' },
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              parameterHints = { enable = true },
              typeHints = { enable = true },
              chainingHints = { enable = true },
            },
            checkOnSave = { command = "clippy" },
            completion = {
              fullFunctionSignatures = { enable = true },
              callable = { snippets = "fill_arguments" },
              postfix = { enable = true },
            },
            hover = {
              documentation = { enable = true },
              actions = { references = { enable = true } },
            },
          }
        }
      })

      -- LSPサーバーを有効化
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('eslint')
      vim.lsp.enable('tailwindcss')
      vim.lsp.enable('cssls')
      vim.lsp.enable('jsonls')
      vim.lsp.enable('pylsp')
      vim.lsp.enable('solargraph')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('dartls')

      -- Diagnostics設定
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 2,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "❌",
            [vim.diagnostic.severity.WARN] = "⚠️",
            [vim.diagnostic.severity.HINT] = "💡",
            [vim.diagnostic.severity.INFO] = "ℹ️",
          }
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Hover/SignatureHelpのボーダー設定
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    event = "InsertEnter",
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
        window = {
          completion = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
            side_padding = 1,
            scrollbar = false,
          },
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = 'Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
            side_padding = 1,
            col_offset = 2,
            scrollbar = false,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        })
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }})
      })
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{ name = 'buffer' }}
      })
    end
  },
  { "hrsh7th/vim-vsnip", event = "InsertEnter" },
}

