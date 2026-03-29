-- 動的ターミナル管理
-- ,t: 新しいターミナルを作成
-- Ctrl+]: ターミナル間を切り替え

local keys = {
  { "<leader>t", "<cmd>lua _add_terminal()<CR>", desc = "New Terminal" },
  { "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", desc = "Toggle Lazygit" },
  { "<leader>fr", "<cmd>lua _flutter_run_toggle()<CR>", desc = "Toggle Flutter Run" },
}

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VimEnter",
  cmd = { "ToggleTerm" },
  keys = keys,
  config = function()
    require("toggleterm").setup({
      size = 20,
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 34,
      },
    })

    local Terminal = require('toggleterm.terminal').Terminal

    -- ターミナル管理
    local terminals = {}
    local current_index = 0

    -- ハイライト設定
    vim.api.nvim_set_hl(0, 'MyTermBorder', { fg = '#00FF00' })
    vim.api.nvim_set_hl(0, 'MyTermBg', { bg = '#1a2e1a' })
    vim.api.nvim_set_hl(0, 'LazygitFloat', { bg = '#2E1437' })

    -- ターミナルウィンドウにタイトルを設定
    local function update_terminal_title(term, num)
      if term.window and vim.api.nvim_win_is_valid(term.window) then
        vim.api.nvim_win_set_config(term.window, {
          title = " Terminal " .. num .. " ",
          title_pos = "center",
        })
        vim.api.nvim_win_set_option(term.window, 'winhighlight', 'FloatBorder:MyTermBorder,NormalFloat:MyTermBg')
      end
    end

    -- 新しいターミナルを作成
    _G._add_terminal = function()
      local num = #terminals + 1
      local term = Terminal:new({
        direction = "float",
        float_opts = {
          border = "rounded",
          width = math.floor(vim.o.columns * 0.7),
          height = math.floor(vim.o.lines * 0.9),
          winblend = 34,
        },
        on_open = function(t)
          vim.cmd("startinsert!")
          vim.defer_fn(function()
            update_terminal_title(t, num)
          end, 10)
        end,
        on_exit = function(t)
          -- terminalsテーブルから削除
          for i, term in ipairs(terminals) do
            if term == t then
              table.remove(terminals, i)
              if current_index >= i then
                current_index = math.max(0, current_index - 1)
              end
              break
            end
          end
        end,
      })
      term._term_num = num  -- 番号を保存
      table.insert(terminals, term)
      current_index = num
      term:open()
    end

    -- ターミナル切り替え
    _G._cycle_terminals = function()
      if #terminals == 0 then
        vim.notify("ターミナルがありません。,t で作成してください", vim.log.levels.INFO)
        return
      end

      -- 現在のターミナルを閉じる
      if current_index > 0 and terminals[current_index] then
        terminals[current_index]:close()
      end

      -- 次のインデックスへ
      current_index = current_index + 1
      if current_index > #terminals then
        current_index = 1
      end

      -- 次のターミナルを開く
      local term = terminals[current_index]
      term:open()
      vim.defer_fn(function()
        update_terminal_title(term, term._term_num or current_index)
      end, 10)
    end

    -- Ctrl+]: ターミナル切り替え
    vim.keymap.set('n', '<C-]>', _G._cycle_terminals, { noremap = true, silent = true, desc = "Cycle terminals" })
    vim.keymap.set('t', '<C-]>', function()
      vim.cmd('stopinsert')
      _G._cycle_terminals()
    end, { noremap = true, silent = true, desc = "Cycle terminals" })

    -- Ctrl+\: 現在のターミナルをトグル
    vim.keymap.set({'n', 't'}, '<C-\\>', function()
      if current_index > 0 and terminals[current_index] then
        local term = terminals[current_index]
        term:toggle()
        -- 開いた時にタイトル更新
        if term:is_open() then
          vim.defer_fn(function()
            update_terminal_title(term, term._term_num or current_index)
          end, 50)
        end
      end
    end, { noremap = true, silent = true, desc = "Toggle current terminal" })

    -- BufEnter時にタイトル更新（コマンド実行後に反映）
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "term://*",
      callback = function()
        if current_index > 0 and terminals[current_index] then
          local term = terminals[current_index]
          if term:is_open() then
            vim.defer_fn(function()
              update_terminal_title(term, term._term_num or current_index)
            end, 50)
          end
        end
      end,
    })

    -- Lazygit
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "double",
        winblend = 0,
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
    })

    _G._lazygit_toggle = function()
      lazygit:toggle()
      vim.defer_fn(function()
        if lazygit:is_open() and lazygit.window and vim.api.nvim_win_is_valid(lazygit.window) then
          vim.api.nvim_win_set_option(lazygit.window, 'winhighlight', 'NormalFloat:LazygitFloat')
        end
      end, 100)
    end

    -- Flutter Run
    vim.api.nvim_set_hl(0, 'FlutterFloat', { bg = '#1a1a2e' })
    local flutter_run = nil

    _G._flutter_run_toggle = function()
      local cwd = vim.fn.getcwd()
      -- WSLパスをWindowsパスに変換
      local win_path = vim.fn.system("wslpath -w " .. cwd):gsub("\n", "")
      if flutter_run == nil then
        flutter_run = Terminal:new({
          cmd = "powershell.exe -Command \"cd '" .. win_path .. "'; flutter run\"",
          dir = cwd,
          direction = "float",
          float_opts = {
            border = "double",
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.8),
            winblend = 0,
          },
          on_open = function(term)
            vim.cmd("startinsert!")
          end,
        })
      end
      flutter_run:toggle()
      vim.defer_fn(function()
        if flutter_run:is_open() and flutter_run.window and vim.api.nvim_win_is_valid(flutter_run.window) then
          vim.api.nvim_win_set_option(flutter_run.window, 'winhighlight', 'NormalFloat:FlutterFloat')
        end
      end, 100)
    end

  end,
}
