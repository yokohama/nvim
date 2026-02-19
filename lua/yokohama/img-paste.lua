-- ============================================
-- Image Paste Utility (WSL + PowerShell)
-- ============================================

-- クリップボードに画像があるか確認
local function has_image_in_clipboard()
  local out = vim.fn.systemlist(
    'powershell.exe -STA -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; [Windows.Forms.Clipboard]::ContainsImage()"'
  )
  return vim.trim(out[#out] or "") == "True"
end

-- ファイル名生成
local function gen_name()
  return os.date("%Y%m%d-%H%M%S") .. "-" .. math.random(100, 999)
end

-- 画像保存
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

-- Markdown挿入
local function insert_markdown_link(path)
  local line = string.format("![](%s)", path)
  vim.api.nvim_put({ line }, "c", true, true)
end

-- 共通ペースト処理
local function paste_image(base_dir, mode)
  if not base_dir then
    vim.notify("Base directory not set", vim.log.levels.ERROR)
    return
  end

  if not has_image_in_clipboard() then
    vim.notify("Clipboard does not contain image/*", vim.log.levels.ERROR)
    return
  end

  vim.fn.mkdir(base_dir, "p")

  local filename = gen_name() .. ".png"
  local abs_path = base_dir .. "/" .. filename

  if not save_img(abs_path) then
    return
  end

  local link_path

  if mode == "ors" then
    local base = vim.fn.getenv("ORS_RECORDS_DIR")
    link_path = abs_path:sub(#base + 2)  -- images/xxx.png

  elseif mode == "private" then
    -- ★ フルパス挿入
    link_path = abs_path

  else
    link_path = abs_path
  end

  insert_markdown_link(link_path)
  vim.notify("Image saved: " .. link_path, vim.log.levels.INFO)
end

-- ============================================
-- 公開Wiki用
-- ============================================
vim.api.nvim_create_user_command("OrsImgPaste", function()
  local base = vim.fn.getenv("ORS_RECORDS_DIR")
  if not base or base == "" then
    vim.notify("ORS_RECORDS_DIR not set", vim.log.levels.ERROR)
    return
  end

  paste_image(base .. "/images", "ors")
end, {})

-- ============================================
-- Private用（フルパス挿入）
-- ============================================
vim.api.nvim_create_user_command("ImgPaste", function()
  local home = vim.fn.getenv("HOME")
  paste_image(home .. "/md_images", "private")
end, {})
