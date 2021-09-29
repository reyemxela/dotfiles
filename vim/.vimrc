"
" .vimrc
"
set nocompatible

colorscheme noctu
"set t_Co=256
syntax enable
set number
set cursorline


" rendering
set termencoding=utf-8
set encoding=utf-8
set scrolloff=1         " number of lines to keep above/below cursor

" indentation
set autoindent
set smartindent
set shiftround

" behavior
set autoread            " read open files again when changed outside Vim
set ttyfast             " improves redrawing on newer computers
set mouse=a             " mouse mode
set foldmethod=marker   " folding
set timeoutlen=1000 ttimeoutlen=0


" tab settings
set tabstop=2           " tab size
set shiftwidth=2        " shift width
set softtabstop=2
set expandtab

" search
set hlsearch            " highlight search
set incsearch           " incremental searching
set ignorecase          " case-insensitive searching...
set smartcase           " ...unless search has an uppercase letter
set showmatch           " when a bracket is inserted, briefly jump to a matching one
set matchtime=3

" wildmenu
set wildmenu            " tab-completion of commands as a menu

" performance
set lazyredraw          " don't update screen during scripts/macros


" misc
set formatoptions+=j    " delete comment chars when joining lines

" mappings

" move by virtual lines
nnoremap j gj
nnoremap k gk

" new line under current position in normal mode
nnoremap <silent><C-o> o<Esc>k
" new line above current position in normal mode
nnoremap <silent>O O<Esc>j
" space toggles fold
nnoremap <space> za

" alt+arrows to move lines up/down
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

" home/end/top/bottom shortcuts on shift+arrows
"noremap <S-Left> ^
"noremap <S-Right> $
"noremap <S-Up> gg
"noremap <S-Down> G

" autocomplete in insert mode
inoremap <S-Tab> <C-P>

inoremap {<cr> {<esc>o}<esc>O

" copy with xclip
vnoremap <C-y> :w !xclip -selection clipboard<CR><CR>

" write with sudo
command W w !sudo tee "%" > /dev/null


" difforig
command! DiffOrig vert new | set bt=nofile | r# | 0d_ | diffthis | wincmd p | diffthis
command! UnDiff wincmd p | q


" Statusline stuff
let g:currentmode={
    \ 'n'       : ' NORMAL ',
    \ 'no'      : ' NORMAL ',
    \ 'v'       : ' VISUAL ',
    \ 'V'       : ' VILINE ',
    \ ''      : ' VIBLOCK',
    \ 'i'       : ' INSERT ',
    \ 'Rv'      : ' VIREPL ',
    \ 'R'       : ' REPLACE'
\}

function GetMode()
    return get(g:currentmode, mode(), toupper('  ' . mode() . '  '))
endfunction

au InsertEnter  * hi SLmode ctermbg=003 ctermfg=000 cterm=bold
au InsertChange * if v:insertmode == "r" | hi SLmode ctermbg=006 ctermfg=000 cterm=bold | else | hi SLmode ctermbg=003 ctermfg=000 cterm=bold | endif
au InsertLeave  * hi SLmode ctermbg=004 ctermfg=007 cterm=bold
hi SLmode ctermbg=004 ctermfg=007 cterm=bold
hi SLbg ctermbg=015 ctermfg=000

set noshowmode
set laststatus=2
set statusline=
set statusline+=%#SLmode#
set statusline+=\ %{GetMode()}\ 
set statusline+=%#SLbg#
set statusline+=\ <<\ %<%f\ %([%M%R]\ %)>>\ 
set statusline+=%y
set statusline+=%=
set statusline+=%#SLmode#
set statusline+=%10.(%l,%c%)
set statusline+=%#SLmode#\ %P\ \ %*
