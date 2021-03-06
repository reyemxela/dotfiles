"
" .vimrc
"
set nocompatible

colorscheme noctu
set t_Co=256
syntax on
set number
set cursorline


" Encoding
set termencoding=utf-8
set encoding=utf-8

" Indentation
set autoindent
set smartindent
set shiftround

" Behavior
set autoread            " read open files again when changed outside Vim
set ttyfast             " Improves redrawing on newer computers
set mouse=a             " Mouse mode
set foldmethod=marker   " folding
set timeoutlen=1000 ttimeoutlen=0


" Tab settings
set tabstop=2           " Tab size
set shiftwidth=2        " Shift width
set softtabstop=2
set expandtab

" Search
set hlsearch                     " Highlight search
set incsearch                    " incremental searching
set ignorecase smartcase         " Case-insensitive searching
set showmatch                    " When a bracket is inserted, briefly jump to a matching one
set matchtime=3

" Wildmenu
set wildmenu

" Mappings
" new line under current position in normal mode
nnoremap <silent><C-o> o<Esc>k
" new line above current position in normal mode
nnoremap <silent>O O<Esc>j
" space toggles fold
nnoremap <space> za

" home/end/top/bottom shortcuts on shift+arrows
noremap <S-Left> ^
noremap <S-Right> $
noremap <S-Up> gg
noremap <S-Down> G

" autocomplete in insert mode
inoremap <S-Tab> <C-P>

" copy with xclip
vnoremap <C-y> :w !xclip -selection clipboard<CR><CR>


" Filetypes
autocmd FileType python set commentstring=#%s
autocmd FileType cfg set commentstring=#%s
autocmd FileType config set commentstring=#%s
autocmd FileType zsh set commentstring=#%s
autocmd FileType dosini set commentstring=;%s


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
hi SLbg ctermbg=007 ctermfg=000 cterm=bold

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
