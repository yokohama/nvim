# Kali/WSL依存箇所調査結果

調査日: 2026-03-21

## 概要

このNeovim設定をmacOSでも使用するにあたり、Kali Linux (WSL2) に依存している部分を調査した。

---

## 依存箇所一覧

### 1. clipboard.lua - クリップボード設定 ✅ 対応済

**ファイル**: `lua/core/clipboard.lua`

| OS | ツール | 設定 |
|----|--------|------|
| macOS | `pbcopy`/`pbpaste` | 自動検出（設定不要） |
| Linux | `xclip` | 明示的に設定 |

**実装済みコード**:
```lua
-- OS判定
local is_mac = vim.fn.has('macunix') == 1
local is_linux = vim.fn.has('unix') == 1 and not is_mac

-- クリップボードプロバイダ設定
if is_mac then
  -- macOS: pbcopy/pbpasteをNeovimが自動検出するため設定不要
elseif is_linux and vim.fn.executable('xclip') == 1 then
  -- Linux: xclip設定
  vim.g.clipboard = { ... }
elseif is_linux then
  vim.notify("xclipが見つかりません。", vim.log.levels.WARN)
end
```

---

### 2. img-paste.lua - 画像ペースト機能 ✅ 対応済

**ファイル**: `lua/yokohama/img-paste.lua`

| OS | ツール | インストール |
|----|--------|-------------|
| macOS | `pngpaste` | `brew install pngpaste` |
| WSL | `powershell.exe` | 標準搭載 |

**実装済みコード**:
```lua
-- OS判定
local is_mac = vim.fn.has('macunix') == 1
local is_wsl = vim.fn.has('unix') == 1 and vim.fn.executable('wslpath') == 1

-- クリップボードに画像があるか確認
local function has_image_in_clipboard()
  if is_mac then
    local res = vim.system({ "pngpaste", "-" }, { text = true }):wait()
    return res.code == 0
  elseif is_wsl then
    -- PowerShellで確認
  end
end

-- 画像保存
local function save_img(abs_path)
  if is_mac then
    vim.system({ "pngpaste", abs_path }, { text = true }):wait()
  elseif is_wsl then
    -- PowerShellで保存
  end
end
```

---

### 3. options.lua - ファイル監視タイマー

**ファイル**: `lua/core/options.lua`

```lua
-- WSL2環境ではinotifyが正しく動作しないため、タイマーで定期的にチェック
local timer = vim.uv.new_timer()
if timer then
    timer:start(500, 500, vim.schedule_wrap(function()
        if vim.api.nvim_get_mode().mode ~= "c" then
            pcall(vim.cmd, "checktime")
        end
    end))
end
```

**macOSでの影響**:
- macOSでは不要（fseventsが正常動作）
- **残しても害はない**（パフォーマンスへの影響は軽微）

---

### 4. options.lua - Python設定

**ファイル**: `lua/core/options.lua`

```lua
vim.g.python3_host_prog = "$HOME/.pyenv/shims/python"
```

**macOSでの影響**:
- pyenvを使っていれば問題なし
- macOSでもpyenvを使うなら変更不要

---

### 5. md.lua - Markdownプレビュー

**ファイル**: `lua/yokohama/md.lua`

```lua
local cmd = string.format("mcat --md-image all --paging always '%s'", filepath)
```

**macOSでの影響**:
- `mcat` がmacOSでもインストールされていれば動作
- 依存ツールの確認が必要

---

## 対応優先度

| 優先度 | ファイル | 対応内容 | 状態 |
|--------|----------|----------|------|
| **高** | `clipboard.lua` | OS判定追加 | ✅ 完了 |
| **高** | `img-paste.lua` | macOS分岐 (pngpaste) | ✅ 完了 |
| **低** | `options.lua` | そのままでOK | - |
| **低** | `md.lua` | `mcat`をmacOSにもインストール | - |

---

## 対応ステータス

- [x] clipboard.lua - OS判定追加 (2026-03-21)
- [x] img-paste.lua - macOS対応 pngpaste (2026-03-21)
- [ ] 動作確認（macOS）
