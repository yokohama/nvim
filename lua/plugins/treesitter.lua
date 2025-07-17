return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        "lua", "vim", "vimdoc", "query", "python", "ruby", "markdown", "markdown_inline",
        -- React Native開発用の言語を追加
        "javascript", "typescript", "tsx", "json", "css", "html", "regex", "jsdoc"
      },
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- インデントの設定
      indent = {
        enable = true,
      },
      -- テキストオブジェクトの設定
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
            ["]a"] = "@parameter.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
            ["]b"] = "@block.outer",
            ["]j"] = "@jsx_element.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.outer",
            ["]I"] = "@conditional.outer",
            ["]L"] = "@loop.outer",
            ["]B"] = "@block.outer",
            ["]J"] = "@jsx_element.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.outer",
            ["[i"] = "@conditional.outer",
            ["[l"] = "@loop.outer",
            ["[b"] = "@block.outer",
            ["[j"] = "@jsx_element.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.outer",
            ["[I"] = "@conditional.outer",
            ["[L"] = "@loop.outer",
            ["[B"] = "@block.outer",
            ["[J"] = "@jsx_element.outer",
          },
        },
      },
    }
  end,
}
