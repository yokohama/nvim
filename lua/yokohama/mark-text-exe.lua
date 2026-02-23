local M = {}

-- WindowsのMarkText.exeを使ってプレビュー表示
local function open_windows_marktext()
  local filepath = vim.api.nvim_buf_get_name(0)

  if filepath == "" then
    vim.notify("No file is currently opened", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({
    "MarkText.exe",
    filepath
  }, { detach = true })
end

vim.api.nvim_create_user_command("MarkText", open_windows_marktext, {})

return M

