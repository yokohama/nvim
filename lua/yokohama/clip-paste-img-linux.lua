-- 使い方:
--   :ClipPasteImg   → 現在編集中の .md と同ディレクトリの md_images/ に保存し、相対リンクで挿入

local function has_image_in_clipboard()
  local out = vim.fn.systemlist("xclip -selection clipboard -t TARGETS -o 2>/dev/null")
  if vim.v.shell_error ~= 0 then
    return false
  end
  for _, l in ipairs(out) do
    if l:match("^image/") then
      return true
    end
  end
  return false
end

local function gen_name()
  return os.date("%Y%m%d-%H%M%S") .. "-" .. math.random(100, 999)
end

-- 相対パス生成（base を起点に ./xxx へ）
local function _relpath(from, base)
  if from:sub(1, #base) == base then
    local sub = from:sub(#base + 2) -- skip trailing '/'
    if sub == "" then return "./" end
    return "./" .. sub
  end
  return from
end

vim.api.nvim_create_user_command("ClipPasteImg", function()
  if not has_image_in_clipboard() then
    vim.notify("Clipboard does not contain image/*", vim.log.levels.ERROR)
    return
  end

  -- 編集中ファイルのディレクトリ（未保存なら CWD）
  local base = vim.fn.expand("%:p:h")
  if base == "" then base = vim.fn.getcwd() end

  -- ★ 保存先は常に md_images/（md と同列）
  local dir = base .. "/md_images/"
  vim.fn.mkdir(dir, "p")

  -- ファイル名
  local name = "img-" .. gen_name() .. ".png"
  local abs_path = dir .. name

  -- 画像を保存
  local cmd = string.format("xclip -selection clipboard -t image/png -o > %q", abs_path)
  local rc = os.execute(cmd)
  if rc ~= true and rc ~= 0 then
    vim.notify("Failed to save image via xclip", vim.log.levels.ERROR)
    return
  end

  -- 相対リンクを挿入（例: ![](./md_images/img-xxxx.png)）
  local rel = _relpath(abs_path, base)
  local line = string.format("![](%s)", rel)
  vim.api.nvim_put({ line }, "c", true, true)

  vim.notify("Image pasted: " .. rel, vim.log.levels.INFO)
end, { nargs = 0 })

