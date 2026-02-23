-- Python設定
vim.g.python3_host_prog = "$HOME/.pyenv/shims/python"

-- 基本的なVimオプション
vim.opt.hidden = true        -- バッファを閉じずに非表示にする
vim.opt.backup = false       -- バックアップファイルを作成しない
vim.opt.writebackup = false  -- 編集中のファイルのバックアップを作成しない
vim.opt.swapfile = false     -- スワップファイルを作成しない
vim.opt.undofile = true      -- 永続的なundoを有効化
vim.opt.updatetime = 300     -- より速い補完
vim.opt.timeoutlen = 500     -- キーマップのタイムアウト時間
vim.opt.mouse = 'a'          -- マウスサポートを有効化
vim.opt.ignorecase = true    -- 検索時に大文字小文字を区別しない
vim.opt.smartcase = true     -- 検索パターンに大文字が含まれる場合は大文字小文字を区別
vim.opt.hlsearch = true      -- 検索結果をハイライト
vim.opt.incsearch = true     -- インクリメンタルサーチを有効化
vim.opt.wrap = false         -- 長い行を折り返さない
vim.opt.scrolloff = 8        -- スクロール時に上下8行を確保
vim.opt.sidescrolloff = 8    -- 横スクロール時に左右8列を確保
vim.opt.showmode = false     -- モード表示を無効化（ステータスラインで表示するため）
vim.opt.termguicolors = true -- TrueColorサポートを有効化
vim.opt.autoread = true      -- 外部でファイルが変更された場合に自動で再読み込み

-- 外部変更を自動検知
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- WSL2環境ではinotifyが正しく動作しないため、タイマーで定期的にチェック
local timer = vim.uv.new_timer()
if timer then
    timer:start(500, 500, vim.schedule_wrap(function()
        if vim.api.nvim_get_mode().mode ~= "c" then
            pcall(vim.cmd, "checktime")
        end
    end))
end
