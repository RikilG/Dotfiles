call plug#begin()
" auto close bracket and quote pairs
Plug 'vim-scripts/auto-pairs-gentle'
" IDE style auto completions
" Plug 'Shougo/deoplete.nvim'
" Plug 'zchee/deoplete-jedi'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" IDE style project explorer/drawer
Plug 'preservim/nerdtree'
" insert mode auto-completions with tab
Plug 'ervandew/supertab'
" search stuff
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " Fuzzy search
Plug 'mileszs/ack.vim'
" themes/colors
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dikiaap/minimalist'
Plug 'gruvbox-community/gruvbox'
" language packs
Plug 'sheerun/vim-polyglot'
" vim learning game
Plug 'ThePrimeagen/vim-be-good', {'do': './install.sh'}
call plug#end()

" set leader key to space
let mapleader=" "
"default settings
filetype plugin indent on
set cursorline
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
"set spell
set termguicolors
set foldmethod=indent
set nofoldenable
set foldnestmax=1
set splitbelow
set splitright
set wrapscan
set report=0
set list
set background=dark
set colorcolumn=80,120

"if has('mouse')
"	set mouse=a
"endif

colorscheme minimalist
"let g:netrw_banner=0
"let g:netrw_altv=1
"let g:deoplete#enable_at_startup=1
let g:SuperTabDefaultCompletionType="<c-n>"
let g:one_allow_italics=1
let g:airline_powerline_fonts=1
let g:airline_theme='ayu_dark'
let g:airline#extensions#tabline#enabled=1
let g:ctrlp_custom_ignore='\v[\/](node_modules|target|dist)|(\.(git|svn))$'

" >>>>>>> Coc Stuff >>>>>>>>>>>
source ~/.config/nvim/cocConfig.vim
" <<<< END of Coc Stuff <<<<<<

" for fzf, make ESC work
if has("nvim")
    " ESC inside a FZF terminal window should exit it
    " rather than going to normal mode
    autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
endif
silent! !git rev-parse --is-inside-work-tree
if v:shell_error == 0
    noremap <C-p> :GFiles --cached --others --exclude-standard<CR>
else
    noremap <C-p> :Files<CR>
endif

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

"disable spell check in terminal
au TermOpen * setlocal nospell

" leader remaps
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :Ack 
"nnoremap <leader><Space> <C-w><C-w>
nnoremap <leader>x :bd<CR>
nnoremap <leader>t :vsp<CR>:exec 'vertical resize '. string(&columns * 0.25)<CR>:term<CR>i
nnoremap <leader>l :Buffers<CR>
nnoremap <leader>h :History<CR>
"nnoremap <leader>T :sp<CR>:exec 'resize '. string(&lines * 0.25)<CR>:term<CR>i
nnoremap <leader>T :tabnew<CR>:term<CR>i

" code templates with <leader>b and <leader>c
source ~/.config/nvim/codeTemplates.vim

" code compilation/run/build with <leader><space>
source ~/.config/nvim/codeBuild.vim
