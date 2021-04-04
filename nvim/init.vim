call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'joshdick/onedark.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'timonv/vim-cargo'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'dag/vim-fish'
Plug 'jiangmiao/auto-pairs'
call plug#end()

" Start Page
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
set noshowmode
syntax on
let g:onedark_color_overrides = {
			\	"comment_grey": {"gui": "#5C7E8C", "cterm": "66", "cterm16": "255"},
			\}
colorscheme onedark
highlight Normal ctermbg=black
highlight nonText ctermbg=black
highlight Pmenu ctermbg=black ctermfg=gray
highlight PmenuSel ctermbg=white ctermfg=gray

let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 1

let g:NERDTreeWinSize=30
map <C-b> :NERDTreeToggle<CR>

let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ }
"Rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0

"Go
autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.organizeImport')

"Node
let g:coc_node_path = system("which node")[:-2] 

set statusline^=%{coc#status()}
set shiftwidth=2
set tabstop=2
set number
