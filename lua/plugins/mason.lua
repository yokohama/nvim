return {
  "williamboman/mason.nvim",
  lazy = false,  -- 起動時に必ず読み込む
  priority = 1000,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason-lspconfig").setup_handlers({
      function(server)
        local opt = {
          capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
        }
        require('lspconfig')[server].setup(opt)
      end
    })
  end,
}

