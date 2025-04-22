return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { ",n", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
  },
  config = function()
    require("nvim-tree").setup({
      -- 基本設定
      sort_by = "case_sensitive",
      view = {
        width = 35,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
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
