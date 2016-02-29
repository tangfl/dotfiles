if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,gbk,latin1
endif
"set color
"set background=light
"set background=dark
"colorscheme solarized
"set modeline
set tabstop=4		" Set default tab width to 4, default is 8
set nocompatible	" Use Vim defaults (much better!)
set nocp
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
set nu
set vb t_vb=
set mouse=a
set smarttab
set smartindent
set cindent
set autoread
set linebreak
set noincsearch
"set expandtab
set shiftwidth=4
set autoindent
set wrap
set cmdheight=1
set showtabline=1
set laststatus=2
set statusline=\ [File]\ %F%m%r%h\ %w\ \ [PWD]\ %r%{CurrectDir()}%h\ \ %=[Line]\ %l,%c\ %=\ %P

function! CurrectDir()
    let curdir = substitute(getcwd(), "", "", "g")
    return curdir
endfunction
if has("multi_byte")
		set encoding=utf-8
		set termencoding=utf-8
	    set formatoptions+=mM
	    set fencs=utf-8,gbk

	    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
	        set ambiwidth=double
	    endif

	    if has("win32")
	        source $VIMRUNTIME/delmenu.vim
	        source $VIMRUNTIME/menu.vim
	        language messages zh_CN.utf-8
	    endif
else
	    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

"
" vim: set et sw=4 ts=4 sts=4 fdm=marker ff=unix fenc=utf8
" add by me
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1
map <F1> :call ToggleSketch()<CR>

