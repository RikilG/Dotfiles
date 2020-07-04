" Coc Configs

" GoTo code navigation
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
" Apply autofix to the current line
nmap <leader>qf <Plug>(coc-fix-current)
" show diagnostics
nnoremap <leader>d :CocList diagnostics<CR>
nnoremap <leader>a :CocList actions<CR>
