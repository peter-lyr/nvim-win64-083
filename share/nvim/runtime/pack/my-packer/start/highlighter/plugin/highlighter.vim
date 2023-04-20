let g:HiMapKeys = 0

let g:HiFollowWait = 0
let g:HiOneTimeWait = 0

nnoremap <leader>hn <cmd>:nohl<CR>

nnoremap <leader>hc <cmd>:Hi+<CR>
vnoremap <leader>hc <ESC><cmd>:Hi+x<CR>
nnoremap <leader>he <cmd>:Hi-<CR>
vnoremap <leader>he <ESC><cmd>:Hi-x<CR>

nnoremap <leader>hw <cmd>:Hi<cword><CR>
nnoremap <leader>hW <cmd>:Hi<cWORD><CR>

nnoremap <leader>hf <cmd>:Hi>><CR>

nnoremap <leader>hb <cmd>:Hi=<CR>
nnoremap <leader>ht <cmd>:Hi==<CR>

nnoremap <c-m> <cmd>:Hi}<CR>
nnoremap <c-n> <cmd>:Hi{<CR>

nnoremap <c-s-m> <cmd>:Hi><CR>
nnoremap <c-s-n> <cmd>:Hi<<CR>
