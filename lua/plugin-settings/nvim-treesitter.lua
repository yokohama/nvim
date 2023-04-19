local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
  ensure_installed = {
    "tsx",
    "toml",
    "fish",
    "php",
    "json",
    "yaml",
    "css",
    "html",
    "lua",
    "ruby",
    "python",
    "javascript"
  },

  highlight = {
    enable = false, -- ハイライトを無効にする。これを有効にするとendwiseと干渉する。
  },
  indent = {
    enable = true, 
  },
  autotag = {
    enable = true, 
  },
  autopairs = {
    enable = true, 
  },
}

--local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
