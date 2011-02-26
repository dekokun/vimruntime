let rails_spec_pat = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'

if expand('%:p') =~ rails_spec_pat
  let g:quickrun_config['ruby.rspec'] = {'command': 'rake', 'args': 'spec -fs -c'}
else
  let g:quickrun_config['ruby.rspec'] = {'command': 'rspec','args': '-fs -c '}
endif

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
function! RSpec()
  let rails_spec_pat = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'
  if expand('%:p') =~ rails_spec_pat
    exe '!bundle exec rspec -f d '.expand('%:p')
  else
    exec '!rspec -fs -c '.expand('%:p')
  endif
endfunction

command! RSpec :call RSpec()
nmap ,r :RSpec<CR>

set nowrap
set sw=2
set sts=2
set ts=8
