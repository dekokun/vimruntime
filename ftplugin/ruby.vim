let g:quickrun_config['ruby.rspec'] = {'command': 'rake spec  RSPECOPTS="-fs -c" '}

" rspecコマンド
function! RSpec ()
  let rails_spec_pat = '\<spec/\(models\|controllers\|views\|helpers\)/.*_spec\.rb$'
  if expand('%:p') =~ rails_spec_pat
    exe '!rake spec SPEC="'.expand('%:p').'" RSPECOPTS="-fs -c -l '.line('.').'"'
  else
    :!spec -fs -c %
  endif
endfunction

au BufRead,BufNewFile *_spec.rb :command! RSpec :call RSpec()

