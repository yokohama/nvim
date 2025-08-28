-- インデント設定
vim.cmd [[
  augroup MyAutoCmd
  autocmd!
  autocmd FileType go              setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType javascript      setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType typescript      setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType html            setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType ruby            setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType python          setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType lua             setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType json            setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType c               setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType cpp             setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType rust            setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType asm             setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType slim            setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
augroup END
]]

