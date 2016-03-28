" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
" Edit to match the system (look in /usr/share/vim/vimfiles/ for avaible ones).
runtime! archlinux.vim



" GENERAL

" Turn on the WiLd menu
set wildmenu

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch

" No annoying sound on errors
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Colors!
syntax on
colorscheme elflord



" VIM AIRLINE

let g:airline_theme             = 'powerlineish'
let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1

set laststatus=2



" TEXT / TABS / INDENTATION

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai      "Auto indent
set si      "Smart indent
set wrap    "Wrap lines



" KEY BINDINGS

" make ',' the leader key
let mapleader=","

" Map <Space> to / (search)
map <space> /

" turn of search highlight
nnoremap <leader><space> :nohlsearch<CR>

" make jk move vertical by visual no by real lines
nnoremap j gj
nnoremap k gk

" map open/close fold to ,f
nnoremap <leader>f za



