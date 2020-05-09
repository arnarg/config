" lets not use arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Left>  <NOP>
inoremap <Right> <NOP>

""""""""""
" VIM-GO "
""""""""""
let g:go_bin_path = $HOME."/go/bin"

""""""""""""
" NERDTREE "
""""""""""""
" NERDTree on ctrl+n
let NERDTreeShowHidden=1
map <silent> <C-n> :NERDTreeToggle<CR>
" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=1

"""""""
" FZF "
"""""""
" make FZF respect gitignore if `ag` is installed
if (executable('ag'))
    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
endif
nnoremap <C-P> :Files<CR>
nnoremap <leader>f :Ag<CR>
nnoremap <C-L> :Lines<CR>
nnoremap <leader>l :BLines<CR>
nnoremap <leader>c :Commits<CR>
nnoremap <leader>h :History<CR>
nnoremap <leader>t :Filetypes<CR>

"""""""""""
" AIRLINE "
"""""""""""
let g:airline_powerline_fonts = 1
let g:airline_theme='wombat'

""""""""""""
" DEOPLETE "
""""""""""""
let g:deoplete#enable_at_startup = 1
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

""""""""""""""""
" NUMBERTOGGLE "
""""""""""""""""
set nu rnu

"""""""""""
" BUFSTOP "
"""""""""""
nnoremap <leader>b :BufstopFast<CR>
nnoremap <leader>, :BufstopBack<CR>
nnoremap <leader>. :BufstopForward<CR>

""""""""
" GOYO "
""""""""
nnoremap <leader>g :Goyo<CR>
