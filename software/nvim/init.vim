lua require('basic')
lua require('keymap')
lua require('plugins')
lua require('lsp')

" enable these to print markdown preview url when using ssh on remote server
" let g:mkdp_open_to_the_world = 1
" let g:mkdp_open_ip = '127.0.0.1' " change to you vps or vm ip
" let g:mkdp_port = 8033
" function! g:EchoUrl(url)
"   :echo a:url
" endfunction
" let g:mkdp_browserfunc = 'g:EchoUrl'


" Open file in Obsidian vault
command IO execute "silent !open 'obsidian://open?vault=vault&file=" . expand('%:r') . "'"
nnoremap <leader>io :IO<CR>

" force save file when open without sudo
command Sudow w !sudo tee % >/dev/null
" match words selected
vnoremap // y/<c-r>"<cr>

