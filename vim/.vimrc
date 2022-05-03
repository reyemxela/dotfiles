set nocompatible

syntax enable


""""" built-in colorscheme
set background=dark

" UI
hi Normal              ctermfg=15
hi Cursor              ctermfg=7     ctermbg=1
hi CursorLine          ctermbg=0     cterm=NONE
hi MatchParen          cterm=bold,underline
hi Pmenu               ctermfg=15    ctermbg=0
hi PmenuThumb          ctermbg=7
hi PmenuSBar           ctermbg=8
hi PmenuSel            ctermfg=0     ctermbg=4
hi ColorColumn         ctermbg=0
hi SpellBad            ctermfg=1     ctermbg=NONE  cterm=underline
hi SpellCap            ctermfg=10    ctermbg=NONE  cterm=underline
hi SpellRare           ctermfg=11    ctermbg=NONE  cterm=underline
hi SpellLocal          ctermfg=13    ctermbg=NONE  cterm=underline
hi NonText             ctermfg=8
hi LineNr              ctermfg=8     ctermbg=0
hi CursorLineNr        ctermfg=11    ctermbg=0
hi Visual              ctermfg=0     ctermbg=15
hi IncSearch           ctermfg=0     ctermbg=13    cterm=NONE
hi Search              ctermfg=0     ctermbg=10
hi StatusLine          ctermfg=15    ctermbg=0     cterm=bold
hi StatusLineNC        ctermfg=8     ctermbg=0     cterm=bold
hi VertSplit           ctermfg=0     ctermbg=0     cterm=NONE
hi TabLine             ctermfg=8     ctermbg=0     cterm=NONE
hi TabLineSel          ctermfg=7     ctermbg=0
hi Folded              ctermfg=6     ctermbg=0     cterm=bold
hi Conceal             ctermfg=6     ctermbg=NONE
hi Directory           ctermfg=12
hi Title               ctermfg=3     cterm=bold
hi ErrorMsg            ctermfg=15    ctermbg=1
hi DiffAdd             ctermfg=0     ctermbg=10
hi DiffChange          ctermfg=0     ctermbg=14
hi DiffDelete          ctermfg=0     ctermbg=9
hi DiffText            ctermfg=0     ctermbg=11    cterm=bold
hi! link CursorColumn  CursorLine
hi! link SignColumn    LineNr
hi! link WildMenu      Visual
hi! link FoldColumn    SignColumn
hi! link WarningMsg    ErrorMsg
hi! link MoreMsg       Title
hi! link Question      MoreMsg
hi! link ModeMsg       MoreMsg
hi! link TabLineFill   StatusLineNC
hi! link SpecialKey    NonText

" generic syntax
hi Delimiter       ctermfg=14
hi Comment         ctermfg=8   cterm=bold
hi Underlined      ctermfg=4   cterm=underline
hi Type            ctermfg=11
hi String          ctermfg=10
hi Keyword         ctermfg=14
hi Todo            ctermfg=15  ctermbg=NONE     cterm=bold,underline
hi Function        ctermfg=10
hi Identifier      ctermfg=12  cterm=NONE
hi Statement       ctermfg=9   cterm=bold
hi Constant        ctermfg=13
hi Number          ctermfg=12
hi Boolean         ctermfg=13
hi Special         ctermfg=13
hi Ignore          ctermfg=8
hi PreProc         ctermfg=12  cterm=bold
hi! link Operator  Delimiter
hi! link Error     ErrorMsg

" show indentation and trailing spaces
hi WhiteSpace ctermfg=8 cterm=underline
match WhiteSpace /^\s\+\|\s\+$/

" list mode settings
set listchars=space:·,trail:·,extends:>,precedes:<,tab:\|\ 


""""" settings

" line numbers
set number

" current line highlighting
set cursorline

" number of lines to keep above/below cursor
set scrolloff=1

" indentation
set autoindent
set smartindent
set shiftround

" behavior
set autoread            " read open files again when changed outside Vim
set ttyfast             " improves redrawing on newer computers
set mouse=a             " mouse mode
set ttymouse=xterm2     " make mouse work in tmux
set foldmethod=marker   " folding
set timeoutlen=1000 ttimeoutlen=0

" tab settings
set tabstop=2           " tab size
set shiftwidth=2        " shift width
set softtabstop=2
set expandtab

" search
set hlsearch            " highlight search
nohlsearch              " prevent search highlights when reloading vimrc
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


""""" key mappings
if &term =~ '^screen'
	" tmux will send xterm-style keys when its xterm-keys option is on
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

" move by virtual lines
nnoremap k gk
nnoremap <Up> gk
nnoremap j gj
nnoremap <Down> gj

" new line under current position in normal mode
nnoremap <silent><C-o> o<Esc>k
" new line above current position in normal mode
nnoremap <silent>O O<Esc>j
" space toggles fold
nnoremap <space> za

" alt+arrows to move lines up/down
nnoremap <silent><M-Down> :m .+1<CR>==
nnoremap <silent><M-Up> :m .-2<CR>==
inoremap <silent><M-Down> <Esc>:m .+1<CR>==gi
inoremap <silent><M-Up> <Esc>:m .-2<CR>==gi
vnoremap <silent><M-Down> :m '>+1<CR>gv=gv
vnoremap <silent><M-Up> :m '<-2<CR>gv=gv

" autocomplete in insert mode
inoremap <S-Tab> <C-P>

" copy with xclip
vnoremap <C-y> :w !xclip -selection clipboard<CR><CR>

" clear search highlight with Ctrl+L
nnoremap <C-L> :noh<CR><C-L>

" print highlight group of current item
nnoremap <F10> :echo synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")<CR>

""""" command mappings

" write with sudo
command W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" reload config
nnoremap confr :source $HOME/.vimrc<CR>

" difforig
command! DiffOrig vert new | set bt=nofile | r# | 0d_ | diffthis | wincmd p | diffthis
command! UnDiff wincmd p | q


""""" code shortcuts
inoremap {<cr> {<esc>o}<esc>O


""""" autocmds
" gofmt on save (needs autoread on)
autocmd BufWritePost *.go silent execute '!gofmt -w % 2>/dev/null'


""""" Statusline stuff
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
