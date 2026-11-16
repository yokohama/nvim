local M = {}

local function show_float(filepath)
  if not filepath or filepath == "" then
    vim.notify("ファイルパスを指定してください", vim.log.levels.ERROR)
    return
  end
  filepath = filepath:gsub("^%s+", ""):gsub("%s+$", "")

  vim.api.nvim_set_hl(0, "ViewFloatBorder", { fg = "#5f87d7", bg = "#06101a" })
  vim.api.nvim_set_hl(0, "ViewFloatBg", { bg = "#06101a", fg = "#c0caf5" })
  vim.api.nvim_set_hl(0, "ViewFloatTitle", { fg = "#7dcfff", bg = "#06101a", bold = true })

  local w = math.floor(vim.o.columns * 0.9)
  local h = math.floor(vim.o.lines * 0.9)

  local mmdflux = os.getenv("HOME") .. "/.cargo/bin/mmdflux"
  local cmd = "sed 's/\\\\n/<br>/g' '" .. filepath:gsub("'", "'\\''") .. "' | " .. mmdflux .. " -f text --node-spacing 1"
  local lines = vim.fn.systemlist(cmd)

  if #lines == 0 then
    vim.notify("mmdflux failed: empty output", vim.log.levels.ERROR)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h,
    col = math.floor((vim.o.columns - w) / 2),
    row = math.floor((vim.o.lines - h) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. vim.fn.fnamemodify(filepath, ":t") .. " ",
    title_pos = "center",
  })

  vim.cmd("stopinsert")
  vim.api.nvim_set_current_win(win)
  vim.wo[win].wrap = false
  vim.wo[win].winblend = 15
  vim.api.nvim_win_set_option(win, "winhighlight",
    "NormalFloat:ViewFloatBg,FloatBorder:ViewFloatBorder,FloatTitle:ViewFloatTitle")

  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
end

function M.show(filepath)
  show_float(filepath)
end

function M.setup()
  vim.api.nvim_create_user_command("MmdView", function(opts)
    if opts.args == "" then
      vim.notify("Usage: :MmdView <file.mmd>", vim.log.levels.WARN)
      return
    end
    local f = opts.args
    if not f:match("^/") then
      f = vim.fn.getcwd() .. "/" .. f
    end
    show_float(f)
  end, { nargs = "?", complete = "file" })
end

return M
