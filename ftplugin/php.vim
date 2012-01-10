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
