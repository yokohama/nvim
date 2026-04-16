local M = {}

-- WindowsのMarkdown Viewerを使ってプレビュー表示
local function open_markdown_viewer()
  local filepath = vim.api.nvim_buf_get_name(0)

  if filepath == "" then
    vim.notify("No file is currently opened", vim.log.levels.ERROR)
    return
  end

  -- WSLパスをWindowsパスに変換
  local winpath = vim.fn.system("wslpath -w " .. vim.fn.shellescape(filepath)):gsub("\n", "")

  vim.fn.jobstart({
    "/mnt/c/Users/yuhei/AppData/Local/Programs/Markdown Viewer/Markdown Viewer.exe",
    winpath
  }, { detach = true })
end

vim.api.nvim_create_user_command("MarkText", open_markdown_viewer, {})

return M

