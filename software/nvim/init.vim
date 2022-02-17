lua require('basic')
lua require('keymap')
lua require('plugins')
lua require('lsp')

" enable these to print markdown preview url when using ssh on remote server
" let g:mkdp_open_to_the_world = 1                                                                                        │
" let g:mkdp_open_ip = '127.0.0.1' " change to you vps or vm ip                                        │
" let g:mkdp_port = 8033                                                                                                  │
" function! g:EchoUrl(url)                                                                                                │
"   :echo a:url                                                                                                         │
" endfunction                                                                                                             │
" let g:mkdp_browserfunc = 'g:EchoUrl'


nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>
