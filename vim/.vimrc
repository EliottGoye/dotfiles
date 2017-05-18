set nocompatible              " be iMproved, required
filetype off                  " required


set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"Syntax
Plugin 'plasticboy/vim-markdown'

"Interface
Plugin 'airblade/vim-gitgutter'

Plugin 'junegunn/vim-emoji'
set completefunc=emoji#complete

Plugin 'ap/vim-css-color'

Plugin 'terryma/vim-multiple-cursors'

Plugin 'raimondi/delimitmate'

Plugin 'tpope/vim-commentary'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='wombat'

call vundle#end()
filetype plugin indent on

if has("syntax")
  syntax on
endif

set number
set autoindent

"Invisible chars
set listchars=tab:▸-,eol:¬,trail:~,extends:>,precedes:<,space:·
highlight SpecialKey ctermfg=8
highlight NonText ctermfg=8 guifg=gray

nmap gl :set list!<CR>

" Jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

set updatetime=100

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
