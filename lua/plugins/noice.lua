-- noice.nvim: メッセージ、コマンドライン、ポップアップメニューのUI改善
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    -- 必須: UIコンポーネント
    "MunifTanjim/nui.nvim",
    -- オプション: 通知表示（おすすめ）
    {
      "rcarriga/nvim-notify",
      opts = {
        -- 通知の表示時間（ミリ秒）
        timeout = 3000,
        -- 通知の最大幅
        max_width = 80,
        -- 通知の位置
        top_down = true,
        -- アニメーションスタイル
        stages = "fade_in_slide_out",
        -- 背景透過
        background_colour = "#000000",
      },
    },
  },
  opts = {
    -- LSP関連の改善
    lsp = {
      -- LSPメッセージをnoiceでオーバーライド
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      -- ホバードキュメントの設定
      hover = {
        enabled = true,
        silent = false,
      },
      -- シグネチャヘルプ
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          throttle = 50,
        },
      },
      -- LSP進捗表示
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30,
      },
    },

    -- プリセット設定（便利なデフォルト）
    presets = {
      -- 検索コマンドラインを下部に表示
      bottom_search = true,
      -- コマンドパレット風の表示
      command_palette = true,
      -- 長いメッセージをスプリットで表示
      long_message_to_split = true,
      -- inc-rename.nvim用（使用していない場合はfalse）
      inc_rename = false,
      -- LSPドキュメントにボーダー追加
      lsp_doc_border = true,
    },

    -- コマンドライン設定
    cmdline = {
      enabled = true,
      -- コマンドラインの表示位置
      view = "cmdline_popup",
      opts = {},
      format = {
        -- 各コマンドタイプのアイコン
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
      },
    },

    -- メッセージ設定
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },

    -- ポップアップメニュー設定
    popupmenu = {
      enabled = true,
      -- nui or cmp
      backend = "nui",
      kind_icons = {},
    },

    -- 通知設定
    notify = {
      enabled = true,
      view = "notify",
    },

    -- ビュー設定
    views = {
      -- コマンドラインポップアップのカスタマイズ
      cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
      -- ポップアップメニューの位置
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
      },
    },

    -- ルーティング設定（メッセージのフィルタリング）
    routes = {
      -- 検索カウントメッセージを非表示
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      -- 「No information available」を非表示
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
    },
  },

  -- キーマップ設定
  keys = {
    -- メッセージ履歴を表示
    { "<leader>nm", "<cmd>Noice<cr>", desc = "Noice Messages" },
    -- 最後のメッセージを表示
    { "<leader>nl", "<cmd>Noice last<cr>", desc = "Noice Last Message" },
    -- エラーを表示
    { "<leader>ne", "<cmd>Noice errors<cr>", desc = "Noice Errors" },
    -- 通知を全て消去
    { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Noice Dismiss All" },
  },
}
