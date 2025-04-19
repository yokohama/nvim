require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "tsx", "typescript", "javascript", "html", "css", "json", "lua"
  },
  highlight = { enable = true },
  indent = { enable = true },
}
