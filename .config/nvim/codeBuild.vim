" Code Build
autocmd filetype c nnoremap <leader><space> :w! /tmp/temp.c<CR>:vsp<CR>:term<CR>igcc /tmp/temp.c -o /tmp/a.out && exec /tmp/a.out<CR>
autocmd filetype cpp nnoremap <leader><space> :w! /tmp/temp.cpp<CR>:vsp<CR>:term<CR>ig++ -std=c++14 -Wall /tmp/temp.cpp -o /tmp/a.out && exec /tmp/a.out<CR>
autocmd filetype python nnoremap <leader><space> :w! /tmp/temp.py<CR>:vsp<CR>:term<CR>iexec python /tmp/temp.py<CR>
" the dc code below is to get min of 120 and current no of cols(-3)
autocmd filetype markdown nnoremap <leader><space> :w! /tmp/temp.md<CR>:term exec glow /tmp/temp.md -w $(dc -e "[120]sM $(($(tput cols) - 3))d 120<Mp")<CR>
