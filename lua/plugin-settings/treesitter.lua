require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "tsx", "typescript", "javascript", "html", "css", "json", "lua", "markdown", "markdown_inline"
  },
  highlight = { enable = true },
  indent = { enable = true },
}
