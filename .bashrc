#!/bin/bash

case $- in
  *i*) ;;
    *) return;;
esac


##### functions
__have()     { type "$1" &>/dev/null; }
__source_if() { [[ -r "$1" ]] && source "$1"; }


##### env
if __have vim; then
export EDITOR="vim"
else
export EDITOR="vi"
fi


##### history
HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000

shopt -s histappend


##### bash options
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar
shopt -s dotglob
shopt -s extglob


##### path
# path stuff stolen from https://github.com/rwxrob/dot
# because it's brilliant
pathappend() {
  declare arg
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//":$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="${PATH:+"$PATH:"}$arg"
  done
} && export pathappend

pathprepend() {
  for arg in "$@"; do
    test -d "$arg" || continue
    PATH=${PATH//:"$arg:"/:}
    PATH=${PATH/#"$arg:"/}
    PATH=${PATH/%":$arg"/}
    export PATH="$arg${PATH:+":${PATH}"}"
  done
} && export pathprepend

pathprepend \
  "$HOME/.local/bin" \
  "$HOME/.local/bin/scripts" \
  "$HOME/Sync/scripts" \
  "$HOME/go/bin"


##### prompt
__ps1() {
  status=$?

  # fg
  local r='\[\e[91m\]' g='\[\e[92m\]' y='\[\e[93m\]' \
        b='\[\e[94m\]' p='\[\e[95m\]' c='\[\e[96m\]' \
        w='\[\e[97m\]' gr='\[\e[37m\]' k='\[\e[30m\]'

  # bg
  local rb='\[\e[101m\]' gb='\[\e[102m\]' yb='\[\e[103m\]' \
        bb='\[\e[104m\]' pb='\[\e[105m\]' cb='\[\e[106m\]' \
        wb='\[\e[107m\]' kb='\[\e[40m\]'

  # misc
  local bold='\[\e[1m\]' x='\[\e[0m\]'

  # status
  sc=$c
  [[ $status != 0 ]] && sc=$r

  # trim pwd
  local pwd="${PWD/#$HOME/\~}"
  local maxlen=35
  (( maxlen > $((COLUMNS - 50)) )) && maxlen=$((COLUMNS - 55))
  (( ${#pwd} > maxlen )) && pwd="..$(echo -n "$pwd" |tail -c$maxlen)"

  # git branch
  branch=$(git branch --show-current 2>/dev/null)
  dirty=
  if [[ -n "$branch" ]]; then
    col=$g
    [[ $branch == main || $branch == master ]] && col=$r
    if [[ -n "$(git status --porcelain -uno 2>/dev/null)" ]]; then
      dirty="+"
    fi
    branch="$gr($bold$col$branch$w$bold$dirty$x$gr)$x"
  fi

  # python venv
  venv=${VIRTUAL_ENV##*/}
  [[ -n "$venv" ]] && venv="$gr($bold$c$venv$x$gr)$x"


  PS1="\n$sc╔$x $rb $yb $gb $cb $wb $k\u@\h $cb $bb $x $w$pwd $branch$venv$x\n$sc╚═$x "
}

PROMPT_COMMAND="__ps1"


#### lesspipe
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"


##### dircolors
if __have dircolors; then
  [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi


##### manpage colors
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\e[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline


##### less options
# -a: skip search results on same screen
# -q: no bell
# -F: just print file if it fits on screen
# -R: allow escape characters through
# -X: don't clear screen
[[ $(less --version |grep -E "less [0-9]+" |cut -d " " -f 2) -ge 543 ]] && mouse='--mouse --wheel-lines 3'
export LESS="$mouse -aqFRX"


##### aliases
if __have exa; then
  alias ls='exa'
  alias l='exa -lg'
  alias la='exa -laag'
  alias ll='exa -lag'
  alias lt='exa -lagT'
else
  alias ls='command ls -vF --color=auto'
  alias l='ls -l'
  alias la='ls -la'
  alias ll='ls -lhA'
fi

alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias du1='du -hd1 |sort -h'

alias chx='chmod +x'

__have vim && alias vi='vim'

if __have apt; then
  alias apts="apt search"
  alias apti="sudo apt install"
  alias aptr="sudo apt remove"
  alias aptud="sudo apt update"
  alias aptug="sudo apt upgrade"
fi

if __have dnf; then
  alias dnf="sudo dnf"
fi


##### completion
__source_if /usr/share/bash-completion/bash_completion

completion=(
  $(cd ~/.local/bin/scripts || exit; grep -rl COMPLETION)
)

for i in "${completion[@]}"; do complete -C "$i" "$i"; done


##### readline options
bind 'set bell-style none'
bind 'set completion-ignore-case on'          # case-insensitive tab-completion
bind 'set menu-complete-display-prefix on'    # display partial and menu right away
#bind 'set completion-prefix-display-length 3' # common prefixes become ellipsis
bind 'set show-all-if-ambiguous on'           # muptiple possibilities show right away
bind 'set page-completions off'               # no `more` for tab results
bind 'set visible-stats on'                   # show filetype characters in completions
bind 'set mark-symlinked-directories off'     # show / after symlinked directories too


##### keybinds
bind '"\e[A": history-search-backward'        # up arrow
bind '"\e[B": history-search-forward'         # down arrow

bind '"\t": menu-complete'                    # tab
bind '"\e[Z": menu-complete-backward'         # shift-tab


##### startup
# if on a tty, interactive, and not already in a tmux session:
if [[ -t 0 ]] && [[ $- = *i* ]] && [[ -z $TMUX ]]; then
  if __have tmux; then
    # grabs latest detached session
    attach=$(tmux 2>/dev/null ls -F \
             '#{session_attached} #{?#{==:#{session_last_attached},},1,#{session_last_attached}} #{session_id}' \
             |awk '/^0/{if ($2 > t){t=$2;s=$3}}; END{print s}')
    if [[ -n "$attach" ]]; then
      out=$(tmux attach -t "$attach")
    else
      out=$(tmux)
    fi
    # if original session was exited and not detached, exit
    if [[ $out == "[exited]" ]]; then
      exit
    fi
  fi
fi
