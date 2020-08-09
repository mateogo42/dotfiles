call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'ycm-core/YouCompleteMe'
Plug 'timonv/vim-cargo'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
call plug#end()

let g:airline_theme='onedark'
syntax on
let g:onedark_color_overrides = {
			\	"comment_grey": {"gui": "#5C7E8C", "cterm": "66", "cterm16": "255"},
			\}
colorscheme onedark
highlight Normal ctermbg=black
highlight Pmenu ctermbg=black ctermfg=gray
highlight PmenuSel ctermbg=white ctermfg=gray

let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 1

let g:NERDTreeWinSize=30
map <C-b> :NERDTreeToggle<CR>

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ }

let g:coc_node_path = system("which node")[:-2] 
set statusline^=%{coc#status()}
set shiftwidth=2
set tabstop=2
set number
