set background=dark
syntax enable
syntax on
colorscheme molokai
set t_Co=256

set encoding=utf8
set syntax=on

set shiftwidth=4
set tabstop=2
set softtabstop=2

set lbr
set tw=500
set ai "auto indent
set si "smart inden
set wrap "wrap lines 

set laststatus=2

set expandtab
set number
set cursorline
filetype indent on
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch

set foldmethod=syntax
set foldcolumn=1
set foldlevel=2
set foldenable
set foldlevelstart=10

filetype plugin on
filetype indent on

set autoread

highlight clear LineNr "transparent bg for num column
"highlight clear SignColumn 
highlight LineNr ctermfg=black
hi CursorLineNr ctermfg=darkgrey

" Powerline
set rtp+=/usr/share/powerline/bindings/vim/

" Always show statusline
set laststatus=2
