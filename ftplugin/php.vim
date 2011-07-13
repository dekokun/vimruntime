"autocomplpopのphp辞書の場所を指定
augroup BufferAu
    autocmd!
    au BufNewFile,BufRead * let g:AutoComplPop_CompleteOption = '.,w,b,u,t'
    au BufNewFile,BufRead *.php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,k~/.vim/dict/php.dict'
augroup END
autocmd FileType php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/php.dict'

function! SyntaxCheck()
    let result = system('php -l '.expand("%:p"))
    echo result
endfunction

function! Test()
    let phpunit_pat = 'Test.php$'
    if expand('%:p') =~ phpunit_pat
        exec '!phpunit --colors '.expand('%:p')
    else
        exec '!phpunit --colors '.expand('%:p:r').'Test.php'
endfunction


let g:ref_phpmanual_path = $HOME . '/.vim/bundle/vim-ref/ref/phpmanual'
