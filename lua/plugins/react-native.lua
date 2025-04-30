-- React Native開発のための設定
return {
  -- Treesitterの拡張: JSX/TSXのサポート強化
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
  },

  -- 自動括弧補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- treesitterと連携
        ts_config = {
          javascript = { "template_string" },
          typescript = { "template_string" },
          javascriptreact = { "template_string" },
          typescriptreact = { "template_string" },
        },
      })
    end,
  },

  -- JSX/TSXのタグを自動的に閉じる
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = {
          "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact"
        },
      })
    end,
  },

  -- 診断情報を見やすく表示
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 10,
        icons = true,
        mode = "workspace_diagnostics",
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = {"<cr>", "<tab>"},
          open_split = {"<c-x>"},
          open_vsplit = {"<c-v>"},
          open_tab = {"<c-t>"},
          jump_close = {"o"},
          toggle_mode = "m",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          close_folds = {"zM", "zm"},
          open_folds = {"zR", "zr"},
          toggle_fold = {"zA", "za"},
          previous = "k",
          next = "j"
        },
      })

      -- キーマッピング
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
    end,
  },

  -- コード整形やリンティングの統合
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- JavaScript/TypeScript
          null_ls.builtins.formatting.prettier.with({
            filetypes = {
              "javascript", "typescript", "javascriptreact", "typescriptreact",
              "json", "jsonc", "css", "html"
            },
          }),
          null_ls.builtins.diagnostics.eslint_d.with({
            filetypes = {
              "javascript", "typescript", "javascriptreact", "typescriptreact"
            },
          }),
          null_ls.builtins.code_actions.eslint_d.with({
            filetypes = {
              "javascript", "typescript", "javascriptreact", "typescriptreact"
            },
          }),
        },
        -- 保存時に自動的にフォーマット
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },

  -- ファイル検索やシンボル検索を強化
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
      { "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          file_ignore_patterns = {
            "node_modules", ".git", "ios/build", "android/build", "android/app/build",
            "ios/Pods", "__tests__", "coverage", ".expo", ".gradle"
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      telescope.load_extension("fzf")
    end,
  },
}

