-- Markdown Preview with glow in float terminal
local M = {}

local Terminal = require('toggleterm.terminal').Terminal
local glow_term = nil

function M.preview()
  local filepath = vim.fn.expand('%:p')

  if filepath == '' then
    vim.notify("ファイルが保存されていません", vim.log.levels.WARN)
    return
  end

  -- 保存されていない変更があれば保存
  if vim.bo.modified then
    vim.cmd('write')
  end

  local cmd = string.format("mcat -p '%s'", filepath)

  if glow_term then
    glow_term:shutdown()
  end

  glow_term = Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false,
    env = {
      TERM = "xterm-256color",
      COLORTERM = "truecolor",
    },
    float_opts = {
      border = "rounded",
      width = math.floor(vim.o.columns * 0.85),
      height = math.floor(vim.o.lines * 0.85),
      winblend = 10,
    },
    on_open = function(term)
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
      -- タイトル設定
      vim.defer_fn(function()
        if term.window and vim.api.nvim_win_is_valid(term.window) then
          vim.api.nvim_set_hl(0, 'MdFloatTitle', { fg = '#FFFFFF' })
          vim.api.nvim_win_set_config(term.window, {
            title = " MD ",
            title_pos = "center",
          })
          vim.api.nvim_win_set_option(term.window, 'winhighlight', 'FloatTitle:MdFloatTitle')
        end
      end, 10)
    end,
  })

  glow_term:toggle()
end

function M.setup()
  vim.api.nvim_create_user_command('Md', M.preview, { desc = "Preview Markdown with glow" })
end

return M
