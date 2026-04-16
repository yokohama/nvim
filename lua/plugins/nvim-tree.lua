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
    -- カスタムコマンドを定義
    local function avante_add_file(node)
      local filepath = node.absolute_path
      local relative_path = vim.fn.fnamemodify(filepath, ":.")

      local sidebar = require('avante').get()

      local open = sidebar and sidebar:is_open()
      -- ensure avante sidebar is open
      if not open then
        require('avante.api').ask()
        sidebar = require('avante').get()
      end

      if sidebar and sidebar.file_selector then
        sidebar.file_selector:add_selected_file(relative_path)
        -- 通知を表示
        vim.notify("ファイルを追加しました: " .. relative_path, vim.log.levels.INFO)
      end
    end

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
      -- キーマッピングを追加
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        -- デフォルトのキーマッピングを設定
        api.config.mappings.default_on_attach(bufnr)
        -- カスタムキーマッピングを追加
        vim.keymap.set('n', ',a', function()
          local node = api.tree.get_node_under_cursor()
          if node then
            avante_add_file(node)
          end
        end, { buffer = bufnr, desc = "Add to Avante Selected Files" })

        -- ,np: フルパスをクリップボードにコピー（WSL2用）
        vim.keymap.set('n', ',np', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
            vim.fn.system('echo -n "' .. node.absolute_path .. '" | clip.exe')
            vim.notify("Copied: " .. node.absolute_path, vim.log.levels.INFO)
          end
        end, { buffer = bufnr, desc = "Copy full path to clipboard" })

        -- ,gx: ファイルをChromeで開く、フォルダはExplorerで開く（WSL2用）
        vim.keymap.set('n', ',gx', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path then
            local win_path = vim.fn.system('wslpath -w "' .. node.absolute_path .. '"'):gsub('\n', '')
            -- isdirectory()はシンボリックリンクを解決して判定する
            if vim.fn.isdirectory(node.absolute_path) == 1 then
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
