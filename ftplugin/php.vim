"autocomplpopのphp辞書の場所を指定
augroup BufferAu
    autocmd!
    au BufNewFile,BufRead * let g:AutoComplPop_CompleteOption = '.,w,b,u,t'
    au BufNewFile,BufRead *.php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,k~/.vim/dict/php.dict'
augroup END
autocmd FileType php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/php.dict'