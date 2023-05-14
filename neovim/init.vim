call plug#begin()
Plug 'ryanoasis/vim-devicons'
Plug 'tc50cal/vim-terminal'
Plug 'RRethy/nvim-base16'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'preservim/tagbar', {'on': 'TagbarToggle'}
Plug 'dkarter/bullets.vim'
Plug 'junegunn/fzf.vim'
Plug 'glepnir/dashboard-nvim'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
call plug#end()

" General Configuration
set path=.,,**
set incsearch
set number
set relativenumber
set mouse=
set autoindent
set tabstop=8
set shiftwidth=4
set smarttab
set expandtab
set encoding=UTF-8
set showmatch
colorscheme onedark

" Tab Configuration
noremap <F1> :tabprevious<CR>
noremap <F2> :tabnext<CR>
noremap <F3> :tabnew<CR>
noremap <F4> :tabnew 

" Search Configuration
nnoremap <C-f>
inoremap <C-f> <Esc>/

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Dashboard
let g:dashboard_default_executive ='fzf'

" CoC Configuration
set completeopt=menuone,longest,preview
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" CoC Python configuration
let g:coc_global_extensions = ['coc-python']

" PyNvim Configuration
let g:python3_host_prog = '%APPDATA%\Local\Programs\Python\Python311\python.exe'
let g:python3_plugin_host_prog = '%APPDATA%\Local\Programs\Python\Python311\python.exe'
