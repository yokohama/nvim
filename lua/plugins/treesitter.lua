return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "vim",
        "vimdoc",
        "tsx", 
        "typescript", 
        "javascript", 
        "html", 
        "css", 
        "json",
        "lua", 
        "markdown", 
        "markdown_inline"
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
