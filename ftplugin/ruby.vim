let rails_spec_pat = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'

if expand('%:p') =~ rails_spec_pat
  let g:quickrun_config['ruby.rspec'] = {'command': 'rake', 'args': 'spec -fs -c'}
else
  let g:quickrun_config['ruby.rspec'] = {'command': 'rspec','args': '-fs -c '}
endif

" rspecコマンド
function! RSpec()
  if expand('%:p') =~ rails_spec_pat
    exe '!rake spec SPEC="'.expand('%:p').'" RSPECOPTS="-fs -c -l '.line('.').'"'
  else
    :!rspec -fs -c %
  endif
endfunction

command! RSpec :call RSpec()
nmap ,r :RSpec<CR>
