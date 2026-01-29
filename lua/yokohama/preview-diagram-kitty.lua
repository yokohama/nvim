local M = {}

local listen_on = vim.env.KITTY_LISTEN_ON or "unix:/tmp/kitty"
local preview_title = "kitty_preview_window"
local preview_cwd = "/tmp"

-- Kittyプレビューウィンドウを閉じる（存在すれば）
local function close_existing_preview_window()
  local id_output = vim.fn.system({ "kitty", "@", "--to", listen_on, "ls" })
  local success, data = pcall(vim.fn.json_decode, id_output)
  if not success or not data then return end

  for _, tab in ipairs(data[1].tabs or {}) do
    for _, win in ipairs(tab.windows or {}) do
      if win.title == preview_title then
        vim.fn.system({
          "kitty", "@", "--to", listen_on, "close-window",
          "--match", "id:" .. win.id
        })
        return
      end
    end
  end
end

-- 現在の Kitty ウィンドウ ID を取得
local function get_current_kitty_window_id()
  local id_output = vim.fn.system({ "kitty", "@", "--to", listen_on, "ls" })
  local success, data = pcall(vim.fn.json_decode, id_output)
  if not success or not data then return nil end

  for _, tab in ipairs(data[1].tabs or {}) do
    for _, win in ipairs(tab.windows or {}) do
      if win.is_focused then
        return win.id
      end
    end
  end
  return nil
end

-- Kitty window を開いて、画像を表示 → 直後に元のウィンドウにフォーカス戻す
local function open_preview_window_with_image(img_path, original_window_id)
  local result = vim.fn.system({
    "kitty", "@",
    "--to", listen_on,
    "launch",
    "--type", "window",
    "--title", preview_title,
    "--cwd", preview_cwd,
    "--hold", "kitten", "icat", img_path
  })

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to launch Kitty preview window", vim.log.levels.ERROR)
    return
  end

  if original_window_id then
    vim.fn.system({
      "kitty", "@", "--to", listen_on,
      "focus-window", "--match", "id:" .. original_window_id
    })
  end
end

-- コア処理: plantuml / mermaid を検出し画像生成してプレビュー
local function render_and_preview()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local start_line, diagram_type = nil, nil
  for i = cursor, 1, -1 do
    local match = lines[i]:match("^```(plantuml)%s*$") or lines[i]:match("^```(mermaid)%s*$")
    if match then
      start_line = i
      diagram_type = match
      break
    end
  end

  local end_line = nil
  for i = cursor, #lines do
    if lines[i]:match("^```%s*$") then
      end_line = i
      break
    end
  end

  if not start_line or not end_line or start_line >= end_line then
    vim.notify("No diagram block under cursor", vim.log.levels.ERROR)
    return
  end

  local source_lines = {}
  for i = start_line + 1, end_line - 1 do
    table.insert(source_lines, lines[i])
  end
  local source = table.concat(source_lines, "\n")
  local hash = vim.fn.sha256(diagram_type .. ":" .. source)
  local cache_dir = "/tmp/nvim_preview"
  vim.fn.mkdir(cache_dir, "p")
  local tmp_file = cache_dir .. "/" .. hash .. "." .. (diagram_type == "mermaid" and "mmd" or "uml")
  local out_file = cache_dir .. "/" .. hash .. ".png"

  if vim.fn.filereadable(out_file) == 0 then
    vim.fn.writefile(vim.split(source, "\n"), tmp_file)

    local cmd
    if diagram_type == "plantuml" then
      cmd = string.format("java -jar /opt/plantuml-1.2025.4.jar -tpng -o %s %s", cache_dir, tmp_file)
    elseif diagram_type == "mermaid" then
      cmd = string.format("mmdc -i %s -o %s", tmp_file, out_file)
    end

    local code = os.execute(cmd)
    if code ~= 0 then
      vim.notify(diagram_type .. " rendering failed", vim.log.levels.ERROR)
      return
    end
  end

  local original_window_id = get_current_kitty_window_id()
  close_existing_preview_window()
  open_preview_window_with_image(out_file, original_window_id)
end

-- :PreviewDiagram コマンド登録
vim.api.nvim_create_user_command("PreviewDiagram", render_and_preview, {})

-- :PreviewClose コマンド登録
vim.api.nvim_create_user_command("PreviewClose", function()
  close_existing_preview_window()
end, {})

-- 自動再描画: plantuml / mermaid 範囲内で :w されたとき
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local cursor = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local start_line = nil
    for i = cursor, 1, -1 do
      if lines[i]:match("^```(plantuml)%s*$") or lines[i]:match("^```(mermaid)%s*$") then
        start_line = i
        break
      end
    end

    local end_line = nil
    for i = cursor, #lines do
      if lines[i]:match("^```%s*$") then
        end_line = i
        break
      end
    end

    if start_line and end_line and start_line < end_line then
      render_and_preview()
    end
  end,
})

-- VimLeave 時にキャッシュ削除
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.fn.delete("/tmp/nvim_preview", "rf")
  end,
})

return M

