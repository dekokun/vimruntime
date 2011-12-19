augroup phpsyntaxcheck
  autocmd!
  autocmd BufWrite *.php w !echo $'\e[0;31m'; a=`php -l` echo $'\e[m'
augroup END

function! Test()
    let phpunit_pat = 'Test.php$'
    if expand('%:p') =~ phpunit_pat
        exec '!phpunit --colors '.expand('%:p')
    else
        exec '!phpunit --colors '.expand('%:h').'/t/'.expand('%:t:r').'Test.php'
    endif
endfunction


let g:ref_phpmanual_path = $HOME . '/.vim/bundle/vim-ref/ref/phpmanual'
