return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose" },
  keys = {
    { ",n", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
  },
  config = function()
    -- フォルダの色設定
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#5c9fd7" })        -- 青
    vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#5c9fd7" })        -- 青（アイコンも）
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#7dcfff" })  -- 水色
    vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#5c9fd7" })   -- 青

    require("nvim-tree").setup({
      -- 基本設定
      sort_by = "case_sensitive",
      view = {
        width = 35,
      },
      renderer = {
        group_empty = true,
        -- Gitステータスアイコンの設定
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
          },
          glyphs = {
            git = {
              unstaged = "⤴",
              unmerged = "",
              renamed = "➜",
              untracked = "+",
              deleted = "",
              ignored = "◌",
            },
            modified = "●",
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      -- Git統合を有効化
      git = {
        enable = true,
        ignore = false,
        timeout = 400,
      },
      -- 未保存ファイルの表示
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      -- キーマッピングを追加
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        -- デフォルトのキーマッピングを設定
        api.config.mappings.default_on_attach(bufnr)
        -- ,np: フルパスをクリップボードにコピー（WSL2用）
        vim.keymap.set('n', ',np', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
            vim.fn.system('powershell.exe -command "Set-Clipboard -Value \'' .. node.absolute_path:gsub("'", "''") .. '\'"')
            vim.notify("Copied: " .. node.absolute_path, vim.log.levels.INFO)
          end
        end, { buffer = bufnr, desc = "Copy full path to clipboard" })

        -- ,t: フォルダならそのフォルダでターミナルを開く
        vim.keymap.set('n', ',t', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
            _G._add_terminal(node.absolute_path)
          end
        end, { buffer = bufnr, desc = "Open terminal in folder" })

        -- ,p: フォルダ上ならそのフォルダにpentest-memoを作成してトグル
        vim.keymap.set('n', ',p', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
            local pentest_memo = require("yokohama.pentest-memo")
            pentest_memo.toggle(node.absolute_path)
          end
        end, { buffer = bufnr, desc = "Toggle Pentest Memo in folder" })

        -- ,P: フォルダ上ならそのフォルダにpentest-memoを作成してフォーカス
        vim.keymap.set('n', ',P', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
            local pentest_memo = require("yokohama.pentest-memo")
            pentest_memo.focus(node.absolute_path)
          end
        end, { buffer = bufnr, desc = "Focus Pentest Memo in folder" })

        -- ,mmd: .mmdファイルをフロートビューアで表示
        vim.keymap.set('n', ',mmd', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path and node.absolute_path:match("%.mmd$") then
            require("yokohama.mmdview").show(node.absolute_path)
          else
            vim.notify(".mmd ファイルの上で実行してください", vim.log.levels.WARN)
          end
        end, { buffer = bufnr, desc = "Preview .mmd in float" })

        -- ,iv: クリップボード画像をフォルダに保存（WSL2用）
        vim.keymap.set('n', ',iv', function()
          local node = api.tree.get_node_under_cursor()
          if not node or not node.absolute_path or vim.fn.isdirectory(node.absolute_path) ~= 1 then
            vim.notify("フォルダの上で実行してください", vim.log.levels.WARN)
            return
          end

          local dest_dir = node.absolute_path
          local filename = os.date("%Y%m%d-%H%M%S") .. ".png"
          local dest_path = dest_dir .. "/" .. filename
          local tmp_wsl = "/mnt/c/temp/clip.png"

          vim.fn.mkdir("/mnt/c/temp", "p")

          local ps_cmd = "powershell.exe -command '"
            .. "Add-Type -AssemblyName System.Windows.Forms; "
            .. [[[System.Windows.Forms.Clipboard]::GetImage().Save("C:\temp\clip.png")]]
            .. "'"

          vim.fn.system(ps_cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("クリップボードに画像がありません", vim.log.levels.ERROR)
            return
          end

          vim.fn.system('mv "' .. tmp_wsl .. '" "' .. dest_path .. '"')
          if vim.v.shell_error ~= 0 then
            vim.notify("ファイルの移動に失敗しました", vim.log.levels.ERROR)
            return
          end

          api.tree.reload()
          vim.notify("Saved: " .. filename, vim.log.levels.INFO)
        end, { buffer = bufnr, desc = "Paste clipboard image to folder" })

        -- ,gx: ファイルをChromeで開く、フォルダはExplorerで開く（WSL2用）
        vim.keymap.set('n', ',gx', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
            local path = node.absolute_path
            -- CSVファイルの場合、BOMがなければ追加
            if path:match("%.csv$") then
              local f = io.open(path, "rb")
              if f then
                local head = f:read(3) or ""
                local content = f:read("*a") or ""
                f:close()
                if head ~= "\xEF\xBB\xBF" then
                  f = io.open(path, "wb")
                  if f then
                    f:write("\xEF\xBB\xBF" .. head .. content)
                    f:close()
                    vim.notify("BOM added: " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
                  end
                end
              end
            end
            local win_path = vim.fn.system('wslpath -w "' .. path .. '"'):gsub('\n', '')
            -- isdirectory()はシンボリックリンクを解決して判定する
            if vim.fn.isdirectory(path) == 1 then
              -- フォルダの場合はWindowsエクスプローラーで開く
              vim.fn.jobstart({'explorer.exe', win_path}, {detach = true})
            else
              -- ファイルの場合はWindows既定のアプリで開く
              vim.fn.jobstart({'cmd.exe', '/c', 'start', '', win_path}, {detach = true})
            end
          end
        end, { buffer = bufnr, desc = "Open in Chrome/Explorer" })
      end,

      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = {
            enable = false,
          },
        },
      },

    })

    -- ウィンドウが2以下（NvimTreeとエディタ1つの場合）の時のみ NvimTree を閉じる
    vim.cmd([[
      function! ConditionalNvimTreeClose()
        if winnr('$') <= 2
          if winnr('$') == 1 && &ft == 'NvimTree'
            quit
          elseif winnr('$') == 2 && &ft != 'NvimTree'
            NvimTreeClose
          endif
        endif
      endfunction

      autocmd QuitPre * call ConditionalNvimTreeClose()
    ]])
  end
}
