return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm" },
  keys = {
    { "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", desc = "Toggle Lazygit" },
  },
  config = function()
    require("toggleterm").setup({
      -- デフォルト設定
      size = 20,
      open_mapping = [[<c-\>]],
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
  end,
}

