"
" .vimrc
"
set nocompatible

colorscheme noctu
set t_Co=16
syntax on
set number


" Encoding
set termencoding=utf-8
set encoding=utf-8

" Indentation
set autoindent
set smartindent
set shiftround

" Behavior
set autoread            " read open files again when changed outside Vim
set ttyfast		" Improves redrawing on newer computers
set mouse=a		" Mouse mode
set foldmethod=marker   " folding


" Tab settings
set tabstop=8		" Tab size
set shiftwidth=4	" Shift width
set softtabstop=4
set expandtab

" Search
set hlsearch			 " Highlight search
set incsearch			 " incremental searching
set ignorecase smartcase " Case-insensitive searching
set showmatch			 " When a bracket is inserted, briefly jump to a matching one
set matchtime=4

" Wildmenu
set wildmenu

" Mappings
" new line under current position in normal mode
nnoremap <silent><C-o> o<Esc>k
" new line above current position in normal mode
"nnoremap <silent>O O<Esc>j
" space toggles fold
nnoremap <space> za

" home/end/top/bottom shortcuts on shift+arrows
noremap <S-Left> ^
noremap <S-Right> $
noremap <S-Up> gg
noremap <S-Down> G

" autocomplete in insert mode
inoremap <Tab> <C-P>
inoremap <S-Tab> <Tab>


" Filetypes
autocmd FileType python set commentstring=#\ %s
autocmd FileType cfg set commentstring=#\ %s
autocmd FileType ini set commentstring=;\ %s

