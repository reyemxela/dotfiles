# shellcheck disable=SC2034,SC1090,SC2032,SC2033

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

BLACKFG=$'\e[30m'   REDFG=$'\e[31m'       GREENFG=$'\e[32m'   YELLOWFG=$'\e[33m'   \
BLUEFG=$'\e[34m'    PURPLEFG=$'\e[35m'    CYANFG=$'\e[36m'    WHITEFG=$'\e[37m'    \
BRBLACKFG=$'\e[90m' BRREDFG=$'\e[91m'     BRGREENFG=$'\e[92m' BRYELLOWFG=$'\e[93m' \
BRBLUEFG=$'\e[94m'  BRPURPLEFG=$'\e[95m'  BRCYANFG=$'\e[96m'  BRWHITEFG=$'\e[97m'

BLACKBG=$'\e[40m'    REDBG=$'\e[41m'       GREENBG=$'\e[42m'    YELLOWBG=$'\e[43m'    \
BLUEBG=$'\e[44m'     PURPLEBG=$'\e[45m'    CYANBG=$'\e[46m'     WHITEBG=$'\e[47m'     \
BRBLACKBG=$'\e[100m' BRREDBG=$'\e[101m'    BRGREENBG=$'\e[102m' BRYELLOWBG=$'\e[103m' \
BRBLUEBG=$'\e[104m'  BRPURPLEBG=$'\e[105m' BRCYANBG=$'\e[106m'  BRWHITEBG=$'\e[107m'

BOLD=$'\e[1m' RESET=$'\e[0m'

##### prompt
__ps1() {
  status=$?

  # status
  sc="${BRCYANFG}"
  [[ ${status} != 0 ]] && sc="${BRREDFG}"

  # trim pwd
  local pwd="${PWD/#$HOME/\~}"
  pwd="${pwd/#\/var$HOME/\~}" # handle /var/home/$USER too for immutable distros
  local maxlen=45
  (( maxlen > $((COLUMNS - 50)) )) && maxlen=$((COLUMNS - 55))
  (( maxlen < 5 )) && maxlen=5
  (( ${#pwd} > maxlen )) && pwd="..${pwd: -${maxlen}}"

  if [[ -O ${PWD} ]]; then
    pwd="\[${BRGREENFG}\]${pwd}\[${RESET}\]"
  elif [[ -w ${PWD} ]]; then
    pwd="\[${BRCYANFG}\]${pwd}\[${RESET}\]"
  else
    pwd="\[${BRREDFG}\]${pwd}\[${RESET}\]"
  fi

  # git branch
  branch=$(git branch --show-current 2>/dev/null)
  dirty=
  if [[ -n "${branch}" ]]; then
    col="${BRGREENFG}"
    [[ ${branch} == main || ${branch} == master ]] && col="${BRREDFG}"
    if [[ -n "$(git status --porcelain -uno 2>/dev/null)" ]]; then
      dirty="+"
    fi
    branch="\[${WHITEFG}\](\[${BOLD}\]\[${col}\]${branch}\[${BRWHITEFG}\]\[${BOLD}\]${dirty}\[${RESET}\]\[${WHITEFG}\])\[${RESET}\]"
  fi

  # python venv
  venv=${VIRTUAL_ENV##*/}
  [[ -n "$venv" ]] && venv="\[${WHITEFG}\](\[${BOLD}\]\[${BRCYANFG}\]${venv}\[${RESET}\]\[${WHITEFG}\])\[${RESET}\]"

  # distrobox prompt color change
  if [ -f /run/.containerenv ] || [ -f /.dockerenv ]; then
    userhost="\[${RESET}\]\[${BRBLACKBG}\]\[${BRWHITEFG}\] \u@\H \[${RESET}\]"
  else
    userhost="\[${RESET}\]\[${BRWHITEBG}\]\[${BLACKFG}\] \u@\H \[${RESET}\]"
  fi

  COLORBARS1="\[${RESET}\]\[${BRREDBG}\] \[${BRYELLOWBG}\] \[${BRGREENBG}\] \[${BRCYANBG}\] \[${RESET}\]"
  COLORBARS2="\[${RESET}\]\[${BRCYANBG}\] \[${BRBLUEBG}\] \[${RESET}\]"

  PS1="\[${RESET}\]\n\[${sc}\]╔\[${RESET}\] ${COLORBARS1}${userhost}${COLORBARS2} ${pwd} ${branch}${venv}\n\[${sc}\]╚═\[${RESET}\] "
}

PROMPT_COMMAND="__ps1"


#### lesspipe
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"


##### dircolors
if __have dircolors; then
# shellcheck disable=SC2015
  [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi


##### manpage colors
export LESS_TERMCAP_mb="${BOLD}${REDFG}"              # begin bold
export LESS_TERMCAP_md="${BOLD}${CYANFG}"             # begin blink
export LESS_TERMCAP_me="${RESET}"                     # reset bold/blink
export LESS_TERMCAP_so="${BOLD}${BLUEBG}${YELLOWFG}"  # begin reverse video
export LESS_TERMCAP_se="${RESET}"                     # reset reverse video
export LESS_TERMCAP_us="${BOLD}${GREENFG}"            # begin underline
export LESS_TERMCAP_ue="${RESET}"                     # reset underline


##### less options
# -a: skip search results on same screen
# -q: no bell
# -F: just print file if it fits on screen
# -R: allow escape characters through
# -X: don't clear screen
[[ $(less --version |grep -E "less [0-9]+" |cut -d " " -f 2) -ge 543 ]] && mouse='--mouse --wheel-lines 3'
export LESS="$mouse -aqFRX"


##### aliases/functions
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias du1='du -hd1 |sort -h'
alias nst='netstat -nap --inet'

alias chx='chmod +x'

if __have eza; then
  alias ls='eza'
  alias l='eza -lg --git'
  alias ll='eza -lag --git'
elif __have exa; then
  alias ls='exa'
  alias l='exa -lg --git'
  alias ll='exa -lag --git'
else
  alias ls='command ls -vF --color=auto'
  alias l='ls -l'
  alias ll='ls -lhA'
fi

if __have bat; then
  alias cat='bat --theme ansi'
fi

if __have vim; then
  alias vi='vim'
fi

if __have apt; then
  alias apt='sudo apt'
fi

if __have dnf; then
  alias dnf='sudo dnf'
fi

if __have pacman; then
  alias pacman='sudo pacman'
fi

if __have yay; then
  alias yay='yay --color always --nocleanmenu --nodiffmenu --noeditmenu'
fi

if __have systemctl; then
  alias sc='sudo systemctl'
  alias scu='systemctl --user'
fi

if __have docker; then
  if __have docker-compose; then
    alias dc='docker-compose'
  else
    alias dc='docker compose'
  fi
  alias dcd='dc down'
  alias dcu='dc up'
  alias dcud='dc up -d'
  alias de='docker exec -it'
  alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Networks}}"'
  alias dpsa='dps -a'
fi

if __have distrobox; then
  alias db='distrobox'
  dbe() {
    if [ -n "$1" ]; then
      args="$@"
    else
      args=$(distrobox ls --no-color |tail -n+2 |awk '{print $3;exit}')
    fi
    distrobox-enter ${args}
  }
fi

if __have distrobox-export; then
  alias dbex='distrobox-export'
fi

if __have distrobox-host-exec; then
  alias dbh='distrobox-host-exec'
fi

if __have just; then
  alias just='just --unstable'
fi


##### completion
__source_if /usr/share/bash-completion/bash_completion

# shellcheck disable=SC2207
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
bind 'set colored-stats on'                   # color file/folder completions like ls
bind 'set mark-symlinked-directories on'      # show / after symlinked directories too


##### keybinds
bind '"\e[A": history-search-backward'        # up arrow
bind '"\e[B": history-search-forward'         # down arrow

bind '"\t": menu-complete'                    # tab
bind '"\e[Z": menu-complete-backward'         # shift-tab


__source_if $HOME/.bash_local


##### startup
# if on a tty, interactive, and not already in a tmux session:
if [[ -t 0 ]] && [[ $- = *i* ]] && [[ -z $TMUX ]] && [[ -z $SKIPTMUX ]]; then
  if __have tmux; then
    export TMUX_TMPDIR=/var/tmp
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
