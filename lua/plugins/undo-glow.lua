return {
  "y3owk1n/undo-glow.nvim",
  event = "VeryLazy",
  config = function()
    require("undo-glow").setup({
      animation = {
        enabled = true,         -- アニメーションを有効化
        duration = 300,         -- アニメーション時間（ミリ秒）
        animation_type = "fade", -- フェードアニメーション
        easing = "in_out_cubic", -- イージング関数
        window_scoped = true,   -- ウィンドウスコープを有効化（分割ビューでの表示を改善）
      },
      highlights = {
        undo = {
          hl_color = { bg = "#693232" }, -- ダークレッド
        },
        redo = {
          hl_color = { bg = "#2F4640" }, -- ダークグリーン
        },
        yank = {
          hl_color = { bg = "#7A683A" }, -- ダークイエロー
        },
        paste = {
          hl_color = { bg = "#325B5B" }, -- ダークシアン
        },
        search = {
          hl_color = { bg = "#5C475C" }, -- ダークパープル
        },
        comment = {
          hl_color = { bg = "#7A5A3D" }, -- ダークオレンジ
        },
        cursor = {
          hl_color = { bg = "#793D54" }, -- ダークピンク
        },
      },
      priority = 4096, -- エクストマークの優先度
    })

    -- TextYankPostイベントでヤンク時のハイライトを設定
    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "ヤンク時にハイライト表示",
      callback = function()
        require("undo-glow").yank()
      end,
    })

    -- キーマッピングの設定
    vim.keymap.set("n", "u", function()
      require("undo-glow").undo()
    end, { noremap = true, desc = "ハイライト付きアンドゥ" })

    vim.keymap.set("n", "<C-r>", function()
      require("undo-glow").redo()
    end, { noremap = true, desc = "ハイライト付きリドゥ" })

    vim.keymap.set("n", "p", function()
      require("undo-glow").paste_below()
    end, { noremap = true, desc = "ハイライト付き下ペースト" })

    vim.keymap.set("n", "P", function()
      require("undo-glow").paste_above()
    end, { noremap = true, desc = "ハイライト付き上ペースト" })

    -- 検索関連のハイライト
    vim.keymap.set("n", "n", function()
      require("undo-glow").search_next()
    end, { noremap = true, desc = "ハイライト付き次検索" })

    vim.keymap.set("n", "N", function()
      require("undo-glow").search_prev()
    end, { noremap = true, desc = "ハイライト付き前検索" })

    -- 検索コマンド終了時のハイライト
    vim.api.nvim_create_autocmd("CmdLineLeave", {
      pattern = { "/", "?" },
      desc = "検索コマンド終了時にハイライト表示",
      callback = function()
        require("undo-glow").search_cmd()
      end,
    })
  end,
}

