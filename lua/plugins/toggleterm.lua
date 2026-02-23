-- ターミナル定義（唯一のソース）
local terminal_defs = {
  { key = "<leader>o", color = "#FFFF00", bg = "#2e2e1a", command = "ors search command", insert = false, title = "ORS", desc = "ORS Terminal" },
  { key = "<leader>t", color = "#00FF00", bg = "#1a2e1a", command = "", insert = true, title = "Terminal", desc = "Terminal" },
  { key = "<leader>c", color = "#DA7756", bg = "#2e1f1a", command = "cd $HOME/life-as-code && claude", insert = true, title = "Claude Code", desc = "Claude Code Terminal" },
  { key = "<leader>h", color = "#FFFFFF", bg = "#2e2e2e", command = "", insert = true, title = "Shell", desc = "Shell Terminal" },
  { key = "<leader>b", multi = 3, color = "#5599FF", bg = "#1a1a2e", title = "Terminals", desc = "3-Column Terminals" },
}

-- keys配列を自動生成
local keys = {}
for _, def in ipairs(terminal_defs) do
  if def.multi then
    table.insert(keys, {
      def.key,
      string.format("<cmd>lua _multi_terminal(%d)<CR>", def.multi),
      desc = def.desc,
    })
  else
    table.insert(keys, {
      def.key,
      string.format("<cmd>lua _my_toggle('%s', '%s', %s, '%s', '%s')<CR>", def.color, def.command, def.insert, def.title, def.bg or ""),
      desc = def.desc,
    })
  end
end
table.insert(keys, { "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", desc = "Toggle Lazygit" })

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VimEnter",
  cmd = { "ToggleTerm" },
  keys = keys,
  config = function()
    require("toggleterm").setup({
      -- デフォルト設定
      size = 20,
      -- open_mapping は手動で設定（multi-terminal対応のため）
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 34,  -- 透明度を30%に設定
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- カスタムハイライトグループを定義
    --vim.api.nvim_set_hl(0, 'LazygitFloat', { bg = '#4A235A' })
    vim.api.nvim_set_hl(0, 'LazygitFloat', { bg = '#2E1437' })

    -- Lazygit設定
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "double",
        winblend = 0,  -- 透明度を0に設定（完全に不透明）
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
    })

    -- カスタムターミナル toggle関数（色、コマンド、インサートモード、タイトル、背景色を外部から注入可能）
    _G._my_toggle = (function()
      local terminals = {}
      return function(color, command, insert_mode, title, bg)
        local key = (color or "") .. (command or "") .. tostring(insert_mode)
        if not terminals[key] then
          local hl_name = "MyTermBorder_" .. key:gsub("[^%w]", "_")
          local hl_bg_name = "MyTermBg_" .. key:gsub("[^%w]", "_")
          vim.api.nvim_set_hl(0, hl_name, { fg = color or '#FFFFFF' })
          if bg and bg ~= "" then
            vim.api.nvim_set_hl(0, hl_bg_name, { bg = bg })
          end
          terminals[key] = Terminal:new({
            direction = "float",
            float_opts = {
              border = "rounded",
              width = math.floor(vim.o.columns * 0.9),
              height = math.floor(vim.o.lines * 0.9),
              winblend = 34,
              highlights = {
                border = hl_name,
                background = "Normal",
              },
            },
            on_create = function(term)
              -- 初回作成時のみコマンドを実行
              if command and command ~= "" then
                vim.defer_fn(function()
                  term:send(command)
                end, 100)
              end
            end,
            on_open = function(term)
              if insert_mode then
                vim.cmd("startinsert!")
              else
                vim.cmd("stopinsert")
              end
            end,
            on_close = function(term)
              -- 何もしない
            end,
          })
        end
        local term = terminals[key]
        local hl_name = "MyTermBorder_" .. key:gsub("[^%w]", "_")
        term:toggle()
        vim.defer_fn(function()
          if term:is_open() then
            local win_id = term.window
            if win_id and vim.api.nvim_win_is_valid(win_id) then
              local hl_bg_name = "MyTermBg_" .. key:gsub("[^%w]", "_")
              local winhighlight = 'FloatBorder:' .. hl_name .. ',FloatTitle:' .. hl_name
              if bg and bg ~= "" then
                winhighlight = winhighlight .. ',NormalFloat:' .. hl_bg_name
              end
              vim.api.nvim_win_set_option(win_id, 'winhighlight', winhighlight)
              -- タイトルを設定
              if title then
                vim.api.nvim_win_set_config(win_id, {
                  title = " " .. title .. " ",
                  title_pos = "center",
                })
              end
            end
          end
        end, 100)
      end
    end)()

    -- マルチターミナル（横並びfloat）- 別モジュールで実装
    local multi_term = require("yokohama.multi-terminal")

    -- Ctrl+\をカスタマイズ: multi-terminalが開いていればそれを閉じる
    -- 何も開いていない場合は何もしない（デフォルトのToggleTermは無効）
    vim.keymap.set({'n', 't'}, '<C-\\>', function()
      if multi_term.is_open() then
        _G._multi_terminal()
      end
      -- multi-terminalが開いていない場合は何もしない
    end, { noremap = true, silent = true, desc = "Toggle terminal" })

    -- グローバル関数を定義
    _G._lazygit_toggle = function()
      lazygit:toggle()
      -- lazygitウィンドウが開いたら背景色を設定
      vim.defer_fn(function()
        if lazygit:is_open() then
          local win_id = lazygit.window
          if win_id and vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_set_option(win_id, 'winhighlight', 'NormalFloat:LazygitFloat')
          end
        end
      end, 100) -- 少し遅延させて確実にウィンドウが作成された後に実行
    end

    -- 明示的なToggleコマンドを追加
    vim.api.nvim_create_user_command('Toggle', function()
      vim.cmd('ToggleTerm')
    end, {})

    -- 開いているターミナルを順番に切り替える機能
    local current_index = 0

    -- ターミナルを開く/閉じるヘルパー関数
    local function toggle_terminal_by_def(def)
      if def.multi then
        _G._multi_terminal(def.multi)
      else
        _my_toggle(def.color, def.command, def.insert, def.title)
      end
    end

    _G._cycle_terminals = function()
      -- 現在開いているターミナルを閉じる
      if current_index > 0 then
        local prev = terminal_defs[current_index]
        toggle_terminal_by_def(prev)
      end
      -- 次のターミナルへ
      current_index = current_index + 1
      if current_index > #terminal_defs then
        current_index = 1
      end
      -- 次のターミナルを開く
      local next_term = terminal_defs[current_index]
      toggle_terminal_by_def(next_term)
    end

    -- ターミナルを順番に切り替え
    vim.keymap.set('n', '<C-]>', _G._cycle_terminals, { noremap = true, silent = true, desc = "Cycle terminals" })
    vim.keymap.set('t', '<C-]>', function()
      vim.cmd('stopinsert')
      _G._cycle_terminals()
    end, { noremap = true, silent = true, desc = "Cycle terminals" })

  end,
}

