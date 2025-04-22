return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  config = function()
    require("smear_cursor").setup({
      -- カーソルを黄色に設定
      cursor_color = "#FFFF00", -- 黄色
      -- その他の設定オプション
      stiffness = 0.6,
      trailing_stiffness = 0.4,
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = true,
    })
  end,
}
