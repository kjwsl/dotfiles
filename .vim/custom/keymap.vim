let mapleader = " "
nnoremap - :Ex<cr>

nnoremap <leader>so :so %<cr>
nnoremap <leader>ww :w<cr>
nnoremap <leader>wa :wa<cr>
nnoremap <leader>qq :confirm qa<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <leader>wQ :waq<cr>

nnoremap <leader>wd <C-w>c<cr>

nnoremap <leader>wh <C-w>h
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wl <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>sh <C-w>v
nnoremap <leader>sj <C-w>s<C-w>j
nnoremap <leader>sk <C-w>s
nnoremap <leader>sl <C-w>v<C-w>l

vnoremap K :move -2<cr>gv
vnoremap J :move +1<cr>gv
