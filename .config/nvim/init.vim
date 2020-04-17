call plug#begin()
" auto close bracket and quote pairs
Plug 'vim-scripts/auto-pairs-gentle'
" IDE style auto completions
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-jedi'
" IDE style project explorer/drawer
Plug 'preservim/nerdtree'
" insert mode auto-completions with tab
Plug 'ervandew/supertab'
" search stuff
Plug 'ctrlpvim/ctrlp.vim'  " Fuzzy search
Plug 'mileszs/ack.vim'
" themes/colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dikiaap/minimalist'
" language packs
Plug 'sheerun/vim-polyglot'
call plug#end()

"default settings
filetype plugin indent on
set nu
set rnu
set ignorecase
set autoindent
set expandtab
set softtabstop=4
set shiftwidth=4
set shiftround
set hidden
set laststatus=2
set display=lastline
set incsearch
set hlsearch
set termguicolors
set foldmethod=indent
set nofoldenable
set foldnestmax=5
set splitbelow
set splitright
set wrapscan
set report=0
set list

"if has('mouse')
"	set mouse=a
"endif

colorscheme minimalist
"let g:netrw_banner=0
"let g:netrw_altv=1
let g:deoplete#enable_at_startup = 1
let g:one_allow_italics=1
let g:airline_powerline_fonts=1
let g:airline_theme='ayu_dark'
let g:ctrlp_custom_ignore='\v[\/](node_modules|target|dist)|(\.(git|svn))$'

" keyboard remaps
vnoremap <C-x> "+x
vnoremap <C-c> "+y
noremap <C-v> "+gP
inoremap <C-v> <C-r>+
noremap <C-q> <C-v>
nnoremap <C-s> :w<CR>
nnoremap <C-n> :vnew<CR>

" terminal remaps
tnoremap <Esc> <C-\><C-N>

" leader remaps
let mapleader=" "
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :Ack 
nnoremap <leader><Space> :bn<CR>
nnoremap <leader>x :bd<CR>
nnoremap <leader>t :vsp<CR>:exec 'vertical resize '. string(&columns * 0.25)<CR>:term<CR>i
"nnoremap <leader>T :sp<CR>:exec 'resize '. string(&lines * 0.25)<CR>:term<CR>i
nnoremap <leader>T :tabnew<CR>:term<CR>i
