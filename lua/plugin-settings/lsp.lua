-- LSPショートカット設定
-- , + gp で、説明をフォバー表示
vim.keymap.set('n', 'gp',  '<cmd>lua vim.lsp.buf.hover()<CR>')


vim.cmd [[
set updatetime=500
highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
augroup lsp_document_highlight
  autocmd!
  autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
  autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
augroup END
]]

-- LSP 設定
require('lspconfig')['pylsp'].setup {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'E111'},
        }
      }
    }
  }
}
