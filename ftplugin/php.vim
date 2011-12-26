augroup phpsyntaxcheck
  autocmd!
  autocmd BufWrite *.php w !echo -n $'\e[0;31m'; a=`php -l` echo -n $'\e[m'
augroup END

function! Test()
    let phpunit_pat = 'Test.php$'
    if expand('%:p') =~ phpunit_pat
        exec '!phpunit --colors '.expand('%:p')
    else
        exec '!phpunit --colors '.expand('%:h').'/t/'.expand('%:t:r').'Test.php'
    endif
endfunction

compiler php

let g:ref_phpmanual_path = $HOME . '/.vim/bundle/vim-ref/ref/phpmanual'
