local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

local nvim_lsp = require('lspconfig')

local servers = { 
  'solargraph', 
  'tsserver',
  'pylsp'
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    flags = {
      debounce_text_changes = 150,
      },
    settings = {
      solargraph = {
        diagnostics = false
      },
      pylsp = {
      }
    }
  }
end
