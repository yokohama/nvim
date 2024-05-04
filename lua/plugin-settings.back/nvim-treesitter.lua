require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = {"markdown", "markdown_inline"},
  },
  indent = {
    enable = false, -- jsxがぶっこわれる。タブが複数勝手に入る。
  },
  autotag = {
    enable = false, -- うざい 
  },
  autopairs = {
    enable = false, -- うざい 
  },
}
