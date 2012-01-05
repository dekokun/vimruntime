" vi互換モードをオフに
set nocompatible

"filetypeの識別(vundleのplugin読み込み完了後にonにする)
filetype off
"インデント
filetype indent on
"プラグイン
filetype plugin on

syntax on

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

 "タブ文字で挿入される量をtabstopと同じにする
set softtabstop=0

 " オートインデント時の幅を４目盛りに
set shiftwidth=4

" 小文字のみの入力の際は大文字小文字を区別せずに検索
set ignorecase
set smartcase

 "閉じ括弧を入力すると対応する括弧にフォーカスが一時的に移動
set showmatch
"上記の時間を設定
set matchtime=3

"y,pでクリップボードを操作できる
set clipboard+=unnamedplus,unnamed

"検索結果をハイライト
set hlsearch

" コマンド履歴を増やす
set history=5000

" 折り返す
set wrap

" インクリメンタル検索を行う
set incsearch

" LeaderをSpaceに
let mapleader = ' '

"vimrc,gvimrcを簡単に編集できるように
nnoremap <silent> <Leader>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Leader>eg  :<C-u>edit $MYGVIMRC<CR>

" - で現在のファイルのあるディレクトリを開く
nnoremap - :<C-u>e %:h<Cr>

noremap j gj
noremap k gk

" タグジャンプの際にジャンプ先が複数ある場合は候補を表示する
nnoremap <C-]> g<C-]>

nnoremap <esc><esc> :noh<CR>

" windows用設定
if has('win32')
    :set runtimepath+=$HOME/.vim,$HOME/.vim/after
endif


"%でdo-endやHTMLのタグの対応先にジャンプできるように
source $VIMRUNTIME/macros/matchit.vim

"snipmateを使用できるように
let snippets_dir = "$HOME/.vim/snippets/"
" snipmate連携
let g:acp_behaviorSnipmateLength = 1

"quickrun.vimの設定
let g:quickrun_config = {}
let g:quickrun_config['ruby.rspec'] = {'command': 'rake spec  RSPECOPTS="-fs -c" '}

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
    autocmd MyAutoCmd BufWritePost .vimrc nested source $MYVIMRC
else
" .vimrcの再読込時にも色が変化するようにする
    autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC |
\if has('gui_running') | source $MYGVIMRC
    autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif

" 文字コードの設定
set encoding=utf-8
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" コメントの色を緑色に
highlight Comment ctermfg=2

" Yで、その場所から最後までをヤンク
nnoremap Y y$

" yyy で全部を貼り付け
nnoremap yyy ggyG

"バッファ操作を快適に
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <Leader>b :ls<CR>:buffer
nnoremap <Leader>f :edit .<CR>
nnoremap <Leader>v :vsplit<CR><C-w><C-w>:ls<CR>:buffer
nnoremap <Leader>V :Vexplore!<CR><CR>


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

"スペース*と記入することにより、カーソル下の単語を置換
nnoremap <expr> <Leader>* ':%substitute/\<' . expand('<cword>') . '\>/'
"スペース:と記入することにより、カーソル下の文字を置換
nnoremap <expr> <Leader>: ':%substitute/' . expand('<cword>') . '/'


"スペース+と記入することにより、カーソル下の単語をvimgrep
nnoremap <expr> <Leader>; ':vimgrep ' . expand('<cword>') . ' **/* \| cwin'

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

" vimgrep時に検索結果の一覧を自動で開く
augroup grepopen
    autocmd!
    autocmd QuickFixCmdPost vimgrep cw
augroup END

" 括弧を自動的に閉じて真ん中にカーソル移動
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
" 開き括弧と閉じ括弧を入力した場合に閉じ括弧の右にカーソル移動
inoremap {} {}<LEFT>
inoremap [] []<LEFT>
inoremap () ()<LEFT>
inoremap "" ""<LEFT>
inoremap '' ''<LEFT>

" shebangでファイルを実行する
function! ShebangExecute()
    let m = matchlist(getline(1), '#!\(.*\)')
    if(len(m) > 2)
        execute '!'. m[1] . ' %'
    else
        execute '!' &ft ' %'
    endif
endfunction
nmap ,e :w<CR>:call ShebangExecute()<CR>

" テスト実行
command! Test :call Test()
nmap ,t :w<CR>:Test<CR>

" 文法確認実行
command! SyntaxCheck :call SyntaxCheck()
nmap ,l :SyntaxCheck<CR>

" Pathの検索を柔軟に
setlocal includeexpr=substitute(v:fname,'^\\/','','') | setlocal path+=;/

" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

":Big the window Big!
command! Big wincmd _ | wincmd |

" rspecファイルのファイルタイプ変更
augroup UjihisaRSpec
  autocmd!
  autocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
augroup END

" crontabを編集するときはバックアップを行わない。行うとcrontabが編集できなくなる
autocmd BufRead /tmp/crontab.* :set nobackup nowritebackup

"neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 1
let g:neocomplcache_min_keyword_length = 3
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_enable_smart_case = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1

autocmd BufFilePost Manpageview* silent execute ":NeoComplCacheCachingBuffer"

"スニペットを展開
imap <silent><C-l>     <Plug>(neocomplcache_snippets_expand)
smap <silent><C-l>     <Plug>(neocomplcache_snippets_expand)
nnoremap <Leader>s  :NeoComplCacheEditSnippets<CR>

" Zencoding
" スペースインデント
let g:user_zen_settings = { 'indentation':'  ' }

" VimFiler
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default=0

" unite.vim
" バッファ一覧
nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> <Leader>um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> <Leader>uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> <Leader>ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

augroup unite
  autocmd!
  " ウィンドウを分割して開く
  autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  " ウィンドウを縦に分割して開く
  autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  autocmd FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
augroup END

" Gundo.vim
nnoremap <F5> :GundoToggle<CR>

" YankRing.vim
let g:yankring_history_dir = expand('$HOME')
let g:yankring_history_file = '.vim_yankring_history'

" git-vim
let g:git_no_map_default = 1
let g:git_command_edit = 'rightbelow vnew'
nnoremap <Leader>gd :<C-u>GitDiff<Enter>
nnoremap <Leader>gD :<C-u>GitDiff --cached<Enter>
nnoremap <Leader>gs :<C-u>GitStatus<Enter>
nnoremap <Leader>gl :<C-u>GitLog<Enter>
nnoremap <Leader>gL :<C-u>GitLog -u \| head -10000<Enter>
nnoremap <Leader>ga :<C-u>GitAdd<Enter>
nnoremap <Leader>gA :<C-u>GitAdd <cfile><Enter>
nnoremap <Leader>gc :<C-u>GitCommit -v<Enter>
nnoremap <Leader>gC :<C-u>GitCommit -v --amend<Enter>
nnoremap <Leader>gp :<C-u>Git push

" Chalice for vimの中のURLエンコード/デコード関数を使いやすくする
function! s:URLEncode()
    let l:line = getline('.')
    let l:encoded = AL_urlencode(l:line)
    call setline('.', l:encoded)
endfunction
function! s:URLDecode()
    let l:line = getline('.')
    let l:decoded = AL_urldecode(l:line)
    call setline('.', l:decoded)
endfunction

command! -nargs=0 -range URLEncode :<line1>,<line2>call <SID>URLEncode()
command! -nargs=0 -range URLGecode :<line1>,<line2>call <SID>URLDecode()


" vundle.vim
set rtp+=~/.vim/vundle.git/
call vundle#rc()
if has('vim_starting')
     set runtimepath+=~/.vim/bundle/neobundle.vim/
     call neobundle#rc(expand('~/.vim/bundle/'))
endif
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-rails'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-surround '
NeoBundle 'motemen/git-vim'
NeoBundle 'msanders/snipmate.vim'
NeoBundle 'vim-scripts/zoom.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'mattn/zencoding-vim'
" NeoBundle 'http://github.com/csexton/jslint.vim.git'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimproc'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'vim-scripts/ShowMarks'
NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'koron/chalice'
NeoBundle 'vim-scripts/errormarker.vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'tpope/vim-endwise'

filetype plugin indent on
"local setting
if filereadable(expand('$HOME/.vimrc_local'))
    source $HOME/.vimrc_local
endif
