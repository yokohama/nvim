return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
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
      end,
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
