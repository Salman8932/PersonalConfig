call plug#begin()
Plug 'preservim/NERDTree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf'
Plug 'sirver/ultisnips'
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
call plug#end()

set number
set relativenumber
set laststatus=2

let g:lightline = {
  \     'active': {
  \         'left': [['mode', 'paste' ], ['readonly', 'filename', 'modified']],
  \         'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding']]
  \     }
  \ }
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let $FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d \! -name ''*.tags'' -printf ''%P\n'''

map ; :Files<CR>

autocmd VimEnter * NERDTree | wincmd p
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
