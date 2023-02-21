set nocompatible
filetype off

set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#rc('$HOME/.vim/bundle')

call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

filetype plugin indent on
filetype plugin on
set encoding=utf8

syntax enable
syntax on
set syntax=on
set t_Co=256

set background=dark
"set background=light
"highlight Normal ctermfg=grey ctermbg=darkgrey

set wildmenu
set ignorecase

"TAB
"set expandtab
set shiftwidth=2
set tabstop=2
"set softtabstop=2
"set expandtab "spaces instead of tab
set ai "auto indent
set si "smart indent
set breakindent "indent overflow

set lbr
set tw=500
set wrap "wrap lines 

"set colorcolumn=80 "wrap guide

set laststatus=2
set linespace=3

set number "line numbers
set cursorline "highlight cursor line
filetype indent on
set lazyredraw
set showmatch
set incsearch
set hlsearch

set foldmethod=syntax
set foldcolumn=0
set foldlevel=2
set foldenable
set foldlevelstart=10

filetype plugin on
filetype indent on

set autoread

"LINES
highlight clear LineNr "transparent bg for num column
"highlight clear SignColumn

" highlight CursorLine ctermbg=236 ctermfg=232

"highlight SignColumn ctermfg=black
"color of line numbers
highlight LineNr ctermfg=236
"hi CursorLineNr ctermfg=darkgray

"INTENT CHAR GUIDE
set list lcs=tab:\|\ "indent line
highlight SpecialKey ctermfg=235
highlight SpecialKey ctermbg=233
"hi SpecialKey ctermfg=black
"hi clear SpecialKey

" Powerline
"set rtp+=/usr/share/powerline/bindings/vim/

" Always show statusline
set laststatus=2

"
"REMAP
"

noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

"DIRECTION
"noremap n h
"noremap e k
"noremap i j
"noremap o l
"noremap h i
"
"COLORS
"

"MAIN BACKGROUND
"hi Normal ctermbg=233

"colorscheme molokai
" colorscheme everblush
colorscheme papercolor

hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE


"highlight Comment ctermfg=darkgrey
" highlight Comment ctermfg=238

"add closing brace and move cursor to left
inoremap { {}<ESC>ha

"
"PLUGINS
"
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" let g:airline_theme='laederon'

Plugin 'scrooloose/nerdtree'
"hotkeys
map <C-\> :NERDTreeToggle<CR>

Plugin 'kien/ctrlp.vim'

Plugin 'severin-lemaignan/vim-minimap'
"minimap hotkeys
let g:minimap_show='<leader>ms'
let g:minimap_update='<leader>mu'
let g:minimap_close='<leader>gc'
let g:minimap_toggle='<leader>gt'

let g:minimap_highlight='Visual'

call vundle#end()            " required
filetype plugin indent on 

