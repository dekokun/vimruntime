"filetypeの識別(vundleのplugin読み込み完了後にonにする)
if !1 | finish | endif

if has('vim_starting')
  if &compatible
    set nocompatible " Be iMproved
  endif
endif

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
" Required:

Plug 'Shougo/vinarise'
Plug 'SirVer/ultisnips'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'google/vim-colorscheme-primary'
Plug 'google/vim-searchindex'
Plug 'maralla/completor.vim'
Plug 'motemen/hatena-vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'racer-rust/vim-racer', {'for': 'rust'}
Plug 'rcmdnk/vim-markdown', {'for': 'markdown'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-visualstar'
Plug 'timcharper/textile.vim'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-scripts/desert256.vim'
Plug 'vim-syntastic/syntastic'

call plug#end()

filetype plugin indent on

let g:syntastic_erlang_checkers=['syntaxerl']
let g:syntastic_rust_checkers = ['cargo']   "" 'cargo'を追加する
let g:vim_markdown_folding_disabled=1


" syntax ハイライトを入れる
" vim-colorscheme-primaryの設定
syntax on
set t_Co=256
set background=dark
colorscheme primary

" 行番号を表示する
set number

 " タブをスペースに変換する
set expandtab

"本物ステータスライン常に表示させておく
set laststatus=2

 " ステータスラインになんやかや書き加える
set statusline=%<%f\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P%{fugitive#statusline()}

 " BSでなんやかや削除できるようになる
set backspace=indent,eol,start

 "タブの幅
set tabstop=4

 "タブ文字で挿入される量をtabstopと同じにする
set softtabstop=0

 " オートインデント時の幅
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

" カーソル位置を表示
set cursorline

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
    set runtimepath+=$HOME/.vim,$HOME/.vim/after
endif


"%でdo-endやHTMLのタグの対応先にジャンプできるように
source $VIMRUNTIME/macros/matchit.vim

"quickrun.vimの設定
let g:quickrun_config = {}
let g:quickrun_config['ruby.rspec'] = {'command': 'rake spec  RSPECOPTS="-fs -c" '}
let g:quickrun_config['markdown'] = {'outputter': 'browser'}

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

" Yで、その場所から最後までをヤンク
nnoremap Y y$

"バッファ操作を快適に
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <Leader>b :ls<CR>:buffer
nnoremap <Leader>f :edit .<CR>
nnoremap <Leader>v :vsplit<CR><C-w><C-w>:ls<CR>:buffer
nnoremap <Leader>V :Vexplore!<CR><CR>


" 入力モード中は、emacsライクに動けるように。
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-e> <end>
inoremap <C-a> <home>
inoremap <C-d> <Del>

" コマンドモード中も上記同様
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-p> <Up>
cnoremap <C-a> <home>
cnoremap <C-d> <Del>

"スペース*と記入することにより、カーソル下の単語を置換
nnoremap <expr> <Leader>* ':%substitute/\<' . expand('<cword>') . '\>/'

"特殊文字(SpecialKey)の見える化。listcharsはlcsでも設定可能。
""trailは行末スペース。
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<,eol:$

"バックアップを行う。
set backup
set swapfile
set backupdir=$HOME/.vim/backup
let &directory = &backupdir
if has('persistent_undo')
    set undodir=~/.vimundo
    set undofile
endif

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal g'\"" |
\ endif

" QuickFixの結果を自動的に開く設定
augroup quickfixopen
    autocmd!
    autocmd QuickFixCmdPost vimgrep cw
    autocmd QuickFixCmdPost make cw
augroup END

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

" crontabを編集するときはバックアップを行わない。行うとcrontabが編集できなくなる
autocmd BufRead /tmp/crontab.* :set nobackup nowritebackup

" git-fugitive
nnoremap <Leader>gd :<C-u>Gdiff<Enter>
nnoremap <Leader>gD :<C-u>Gdiff --cached<Enter>
nnoremap <Leader>gs :<C-u>Gstatus<Enter>
nnoremap <Leader>gl :<C-u>Glog<Enter>
nnoremap <Leader>gL :<C-u>Glog -u \| head -10000<Enter>
nnoremap <Leader>ga :<C-u>Gwrite<Enter>
nnoremap <Leader>gA :<C-u>Gwrite <cfile><Enter>
nnoremap <Leader>gc :<C-u>Gcommit -v<Enter>
nnoremap <Leader>gC :<C-u>Gcommit -v --amend<Enter>
nnoremap <Leader>gp :<C-u>Git push


" vim-indent-guide
let g:indent_guides_auto_colors = 0
hi IndentGuidesEven ctermbg=lightgrey
let g:indent_guides_enable_on_vim_startup = 1

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

" syntastic
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['html'] }

"local setting
if filereadable(expand('$HOME/.vimrc_local'))
    source $HOME/.vimrc_local
endif

" Open junk file.
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  " let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  let l:filename = l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.md')
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction"}}}
nnoremap <Leader>, :<C-u>:JunkFile<Enter>

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'

set hidden
let g:racer_cmd = '$HOME/.cargo/bin/racer'
autocmd BufNewFile,BufRead *.crs setf rust
autocmd BufNewFile,BufRead *.rs  let g:quickrun_config.rust = {'exec' : 'cargo run'}
autocmd BufNewFile,BufRead *.crs let g:quickrun_config.rust = {'exec' : 'cargo script %s -- %a'}

" ctrlp.vim
" デフォルトのc-pはbuffer操作で使用しているので変える
let g:ctrlp_map = '<c-r>'

" golang
" errをハイライト
autocmd FileType go :highlight goErr cterm=bold ctermfg=214
autocmd FileType go :match goErr /\<err\>/
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

