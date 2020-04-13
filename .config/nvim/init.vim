call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim'
Plug 'ervandew/supertab'
Plug 'jceb/vim-orgmode'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

"deoplete config
let g:deoplete#enable_at_startup = 1

"default settings
filetype plugin indent on
set nu
set rnu
set ignorecase
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
if has('mouse')
	set mouse=a
endif

"keyboard remaps
vnoremap <C-x> "+x
vnoremap <C-c> "+y
noremap <C-v> "+gP
inoremap <C-v> <C-r>+
noremap <C-q> <C-v>
