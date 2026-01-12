return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",

  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", enabled = false },
  },

  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "python", "ruby",
        "markdown", "markdown_inline",
        "javascript", "typescript", "tsx",
        "json", "css", "html",
        "regex", "jsdoc",
      },

      sync_install = true,
      auto_install = true,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      indent = {
        enable = true,
      },

      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["aj"] = "@jsx_element.outer",
            ["ij"] = "@jsx_element.inner",
          },
        },

        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
        },
      },
    }
  end,
}

