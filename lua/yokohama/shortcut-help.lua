-- Shortcut Help: mdcatでショートカットキーヘルプを表示
local M = {}

local Terminal = require('toggleterm.terminal').Terminal
local help_term = nil

-- このスクリプトと同じディレクトリのMDファイルパスを取得
local function get_md_path()
  local source = debug.getinfo(1, "S").source:sub(2)
  local dir = vim.fn.fnamemodify(source, ":h")
  return dir .. "/shortcut-help.md"
end

function M.is_open()
  return help_term and help_term:is_open()
end

function M.open()
  local filepath = get_md_path()

  if vim.fn.filereadable(filepath) == 0 then
    vim.notify("shortcut-help.md が見つかりません: " .. filepath, vim.log.levels.WARN)
    return
  end

  if help_term then
    help_term:shutdown()
  end

  local cmd = string.format("mdcat -p '%s'", filepath)

  help_term = Terminal:new({
    cmd = cmd,
    direction = "float",
    close_on_exit = false,
    env = {
      TERM = "xterm-256color",
      COLORTERM = "truecolor",
    },
    float_opts = {
      border = "rounded",
      width = math.floor(vim.o.columns * 0.7),
      height = math.floor(vim.o.lines * 0.7),
      winblend = 10,
    },
    on_open = function(term)
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
      -- タイトル設定
      vim.defer_fn(function()
        if term.window and vim.api.nvim_win_is_valid(term.window) then
          vim.api.nvim_set_hl(0, 'ShortcutHelpFloatTitle', { fg = '#FFFFFF' })
          vim.api.nvim_win_set_config(term.window, {
            title = " Shortcut Help ",
            title_pos = "center",
          })
          vim.api.nvim_win_set_option(term.window, 'winhighlight', 'FloatTitle:ShortcutHelpFloatTitle')
        end
      end, 10)
    end,
  })

  help_term:toggle()
end

function M.close()
  if M.is_open() then
    help_term:close()
  end
end

function M.toggle()
  if M.is_open() then
    M.close()
  else
    M.open()
  end
end

-- キーマップ設定
function M.setup()
  vim.keymap.set('n', '<leader>h', M.toggle, { noremap = true, silent = true, desc = "Toggle Shortcut Help" })
end

return M
