
" GENERAL

" if the nocompatible below is not enough,
" edit to match the system's default runtime
" (look in /usr/share/vim/vimfiles/ for avaible ones).
"runtime! archlinux.vim
"runtime! debian.vim

" Use Vim defaults instead of 100% vi compatibility
set nocompatible

" do not load some defaults file if ~/.vimrc is missing
let skip_defaults_vim=1

" more powerful backspacing
set backspace=indent,eol,start

" keep 50 lines of command line history
set history=50

" show the cursor position all the time
set ruler

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

" Disable mouse usage by default
set mouse=

" No annoying sound on errors
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Colors!
syntax on
colorscheme elflord

" Suffixes that get lower priority when doing tab completion for filenames.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg


" PATHOGEN

silent! call pathogen#infect()

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
set shiftwidth=2
set tabstop=2

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

" switching mouse mode
noremap M :call ToggleMouse() <CR>

function! ToggleMouse()
  if &mouse == 'a'
    set mouse=
    echo "Mouse usage disabled"
  else
    set mouse=a
    echo "Mouse usage enabled"
  endif
endfunction
