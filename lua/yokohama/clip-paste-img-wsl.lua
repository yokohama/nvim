-- 使い方
-- :ClipPasteImg   → 現在編集中の .md と同ディレクトリの md_images/ に保存し、相対リンクで挿入

local IMG_DIR = "md_images"

local function has_image_in_clipboard()
  local out = vim.fn.systemlist(
    'powershell.exe -STA -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; [Windows.Forms.Clipboard]::ContainsImage()"'
  )
  return vim.trim(out[#out] or "") == "True"
end

local function get_current_and_img_dirs()
  local current_dir = vim.fn.expand("%:p:h")
  if current_dir == "" then current_dir = vim.fn.getcwd() end

  local img_dir = current_dir .. "/" .. IMG_DIR

  return img_dir, current_dir
end

local function gen_name()
  return os.date("%Y%m%d-%H%M%S") .. "-" .. math.random(100, 999)
end

local function save_img(abs_path)
  local win_path = vim.fn.systemlist({ "wslpath", "-w", abs_path })[1]

  local ps1 = vim.fn.tempname() .. ".ps1"
  local lines = {
    "Add-Type -AssemblyName System.Drawing",
    "Add-Type -AssemblyName System.Windows.Forms",
    "$img = [System.Windows.Forms.Clipboard]::GetImage()",
    "if ($null -eq $img) { exit 1 }",
    "$img.Save($args[0], [System.Drawing.Imaging.ImageFormat]::Png)",
  }
  vim.fn.writefile(lines, ps1)

  local ps1_win = vim.fn.systemlist({ "wslpath", "-w", ps1 })[1]
  local res = vim.system(
    { "powershell.exe", "-STA", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", ps1_win, win_path },
    { text = true }
  ):wait()

  os.remove(ps1)

  if res.code ~= 0 then
    vim.notify("Failed to save image via PowerShell\n" .. (res.stderr or ""), vim.log.levels.ERROR)
    return false
  end
  return true
end

-- 相対パス生成（current_dir を起点に ./xxx へ）
local function relpath(from, base)
  if from:sub(1, #base) == base then
    return "./" .. from:sub(#base + 2)
  end
  return from
end

-- 相対リンクを挿入（例: ![](./md_images/img-xxxx.png)）
local function insert_link(abs_path, current_dir)
  local rel = relpath(abs_path, current_dir)
  local line = string.format("![](%s)", rel)
  vim.api.nvim_put({ line }, "c", true, true)
  return rel
end

vim.api.nvim_create_user_command("ClipPasteImg", function()
  if not has_image_in_clipboard() then
    vim.notify("Clipboard does not contain image/*", vim.log.levels.ERROR)
    return
  end

  -- ★ 保存先は常に md_images/（md と同列）
  local img_dir, current_dir = get_current_and_img_dirs()
  vim.fn.mkdir(img_dir, "p")

  -- ファイルパス
  local abs_path = img_dir .. "/" .. "img-" .. gen_name() .. ".png"

  if save_img(abs_path) then
    local rel = insert_link(abs_path, current_dir)
    vim.notify("Image pasted: " .. rel, vim.log.levels.INFO)
  end
end, { nargs = 0 })
