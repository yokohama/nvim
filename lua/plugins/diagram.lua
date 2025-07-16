return {
  "3rd/diagram.nvim",
  dependencies = {
    "3rd/image.nvim",
  },
  ft = { "markdown" }, -- markdownファイルでのみ読み込み
  config = function()
    -- エラーハンドリングを追加
    local ok, diagram = pcall(require, "diagram")
    if not ok then
      vim.notify("diagram.nvim could not be loaded", vim.log.levels.ERROR)
      return
    end
    diagram.setup({
      integrations = {
        require("diagram.integrations.markdown"),
      },
      events = {
        render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
        clear_buffer = {"BufLeave"}, -- 空にしてダイアグラムを常に表示
      },
      renderer_options = {
        mermaid = {
          background = "transparent", -- nil | "transparent" | "white" | "#hex"
          theme = "dark", -- nil | "default" | "dark" | "forest" | "neutral"
          scale = 1,
          -- CLIオプションを直接指定
          cli_args = { "--theme", "dark", "--backgroundColor", "transparent" },
        },
        gnuplot = {
          theme = "dark",
        },
      },
    })
    -- デバッグ用の通知
    vim.notify("diagram.nvim loaded with dark theme and CLI args", vim.log.levels.INFO)
  end,
}
