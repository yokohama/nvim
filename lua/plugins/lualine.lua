return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local theme = require("lualine.themes.powerline")

    theme.normal = {
  a = { fg = "#1d2021", bg = "#fb4934", gui = "bold" },
  b = { fg = "#ebdbb2", bg = "#cc241d" },
  c = { fg = "#ebdbb2", bg = "#3c3836" },
}

    theme.inactive = {
      a = { fg = "#1d2021", bg = "#b48ead" },
      b = { fg = "#1d2021", bg = "#b48ead" },
      c = { fg = "#1d2021", bg = "#b48ead" },
    }

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = theme,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {},
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {{
          'filename',
          file_status = true,
          path = 0, -- filename only
        }},
        lualine_x = {
          {
            'diagnostics',
            sources = { "nvim_diagnostic" },
            symbols = {
              error = ' ',
              warn  = ' ',
              info  = ' ',
              hint  = ' ',
            },
          },
          --'encoding',
          'filetype',
        },
        --lualine_y = { 'progress' },
        lualine_y = {},
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{
          'filename',
          file_status = true,
          path = 1, -- relative path
        }},
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'fugitive' },
    })
  end,
}
