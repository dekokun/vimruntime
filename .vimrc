" vi互換モードをオフに
set nocompatible

"filetypeの識別(vundleのplugin読み込み完了後にonにする)
filetype off
"インデント
filetype indent on
"プラグイン
filetype plugin on

" 行番号を表示する
set number

 " タブをスペースに変換する
set expandtab

"本物ステータスライン常に表示させておく
set laststatus=2

 " ステータスラインになんやかや書き加える
set statusline=%<%f\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

 " BSでなんやかや削除できるようになる
set backspace=indent,eol,start

 "タブの幅を４目盛りに
set tabstop=4

 " オートインデント時の幅を４目盛りに
set shiftwidth=4

 "閉じ括弧を入力すると対応する括弧にフォーカスが一時的に移動
set showmatch
"上記の時間を設定
set matchtime=3

"y,pでクリップボードを操作できる
set clipboard+=unnamed

"検索結果をハイライト
set hlsearch

" コマンド履歴を増やす
set history=5000

"vimrc,gvimrcを簡単に編集できるように
nnoremap <silent> <Space>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Space>eg  :<C-u>edit $MYGVIMRC<CR>

" - で現在のファイルのあるディレクトリを開く
nnoremap - :<C-u>e %:h<Cr>

"F5やS-F5を押すことにより、NOTEPADライクに日付が挿入できる
map <F5> a<C-R>=strftime("%H:%M %Y/%m/%d")<CR>
map <S-F5> i<C-R>=strftime("%H:%M %Y/%m/%d")<CR>

syntax on

nnoremap j gj
nnoremap k gk


nnoremap <esc><esc> :noh<CR>

" windows用設定
if has('win32')
    :set runtimepath+=$HOME/.vim,$HOME/.vim/after
endif


"%でdo-endやHTMLのタグの対応先にジャンプできるように
source $VIMRUNTIME/macros/matchit.vim
"本来下記1行は必要ないはず（自動的に読み込まれる）のだがなぜか会社のwindowsだと必要…理由不明…
"source $HOME/.vim/plugin/snipMate.vim
"source $HOME/.vim/after/plugin/snipMate.vim
"snipmateを使用できるように
let snippets_dir = "$HOME/.vim/snippets/"
" snipmate連携
let g:acp_behaviorSnipmateLength = 1

" pathogen.vim において、自動的にbundleディレクトリ下も読み込む
"call pathogen#runtime_append_all_bundles()

"quickrun.vimの設定
let g:quickrun_config = {}
"let g:quickrun_config['ruby.rspec'] = {'command': 'rake spec RSPECOPTS="-fs -c -l'}
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

"自動的にインデント
set autoindent

"pasteのトグルをF11に割り当て
set pastetoggle=<F11>

"全角スペースを＿と表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

" 自動的にVIMRC、GVIMRCの設定を読み込むように
augroup MyAutoCmd
  autocmd!
augroup END


if !has('gui_running') && !(has('win32') || has('win64'))
" .vimrcの再読込時にも色が変化するようにする
    autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
" .vimrcの再読込時にも色が変化するようにする
    autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC |
\if has('gui_running') | source $MYGVIMRC
    autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif


"autocomplpop.vimの色の設定
highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4


" Yで、その場所から最後までをヤンク
nnoremap Y y$

" yyy で全部を貼り付け
nnoremap yyy ggyG

"バッファ操作を快適に
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <Space>b :ls<CR>:buffer
nnoremap <Space>f :edit .<CR>
nnoremap <Space>v :vsplit<CR><C-w><C-w>:ls<CR>:buffer
nnoremap <Space>V :Vexplore!<CR><CR>


"タブ操作を快適に
nnoremap <Up> :tabedit
nnoremap <Down> :tabclose
nnoremap <Left> :tabprev<CR>
nnoremap <Right> :tabnext<CR>


" 入力モード中は、emacsライクに動けるように。
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-e> <end>
inoremap <C-a> <home>
inoremap <C-d> <Del>
inoremap <C-w> <esc>cb<Del>

" コマンドモード中も上記同様
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-p> <Up>
cnoremap <C-a> <home>
cnoremap <C-d> <Del>

" 検索時に結果が中央に来るようにする
"nmap n nzz
"nmap N Nzz
"nmap * *zz
"nmap # #zz
"nmap g* g*zz
"nmap g# g#zz

" エンターにて、その場で改行(quickfixウインドウの中でジャンプできるよう
" これは外す)
" nnoremap <CR> i<CR><esc>

"スペース*と記入することにより、カーソル下の単語を置換
nnoremap <expr> <Space>* ':%substitute/\<' . expand('<cword>') . '\>/'
"スペース:と記入することにより、カーソル下の文字を置換
nnoremap <expr> <Space>: ':%substitute/' . expand('<cword>') . '/'


"スペース+と記入することにより、カーソル下の単語をvimgrep
nnoremap <expr> <Space>; ':vimgrep ' . expand('<cword>') . ' **/* \| cwin'

"特殊文字(SpecialKey)の見える化。listcharsはlcsでも設定可能。
""trailは行末スペース。
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:$

"バックアップを行う。
set backup
set swapfile
set backupdir=$HOME/.vim/backup
let &directory = &backupdir

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal g'\"" |
\ endif

" shebangでファイルを実行する
function! ShebangExecute()
    let m = matchlist(getline(1), '#!\(.*\)')
    if(len(m) > 2)
        execute '!'. m[1] . ' %'
    else
        execute '!' &ft ' %'
    endif
endfunction
nmap ,e :call ShebangExecute()<CR>
"
" inserst mode
"set paste
"

" Alignを日本語環境で使用するための設定
:let g:Align_xstrlen = 3

":Big the window Big!
command! Big wincmd _ | wincmd |

"autocomplpopのphp辞書の場所を指定
augroup BufferAu
    autocmd!
    au BufNewFile,BufRead * let g:AutoComplPop_CompleteOption = '.,w,b,u,t'
    au BufNewFile,BufRead *.php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,k~/.vim/dict/php.dict'
augroup END
autocmd FileType php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/php.dict'

" rspecファイルのファイルタイプ変更
augroup UjihisaRSpec
  autocmd!
  autocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
augroup END

"password file
if filereadable(expand('$HOME/.vimrc_local'))
    source $HOME/.vimrc_local
endif

" crontabを編集するときはバックアップを行わない。行うとcrontabが編集できなくなる
autocmd BufRead /tmp/crontab.* :set nobackup nowritebackup

" Nerd Commenterの設定
let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1
nmap <Leader>/ <Plug>NERDCommenterToggle
vmap <Leader>/ <Plug>NERDCommenterToggle
nmap <Leader>/a <Plug>NERDCommenterAppend
nmap <leader>/$ <Plug>NERDCommenterToEOL
vmap <Leader>/s <Plug>NERDCommenterSexy
vmap <Leader>/b <Plug>NERDCommenterMinimal

" vundle.vim
set rtp+=~/.vim/vundle.git/
call vundle#rc()


Bundle 'ref.vim'
Bundle 'quickrun.vim'
Bundle 'quickrun'
Bundle 'rails.vim'
Bundle 'ruby.vim'
Bundle 'surround.vim'
Bundle 'git@github.com:motemen/git-vim.git'
Bundle 'The-NERD-Commenter'

filetype plugin indent on
