local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
  ensure_installed = {
--    "tsx",
    "php",
    "json",
    "yaml",
    "css",
    "html",
    "lua",
    "ruby",
    "python",
    "javascript",
--   "typescript",
  },

  highlight = {
    enable = true,
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

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
--parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
