let g:quickrun_config['ruby.rspec'] = {'command': 'rspec','args': '-fs -c '}

" rspecコマンド(行番号指定)
function! RSpecLine()
  let rails_spec_pat = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'
  if expand('%:p') =~ rails_spec_pat
    exe '!bundle exec rspec -f d '.expand('%:p').':'.line('.')
  else
    exe '!rspec -fs -c -l '.line('.').' '.expand('%:p')
  endif
endfunction

command! RSpecLine :call RSpecLine()
nmap ,rl :RSpecLine<CR>

" rspecコマンド(ファイル全実行)
function! Test()
  let rails_spec_pat = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'
  if expand('%:p') =~ rails_spec_pat
    exe '!bundle exec rspec -f d '.expand('%:p')
  else
    exec '!bundle exec rspec  -fs -c '.expand('%:p')
  endif
endfunction


function! SyntaxCheck()
    let result = system('ruby -cw '.expand("%:p"))
    echo result
endfunction


set nowrap
set sw=2
set sts=2
set ts=8
