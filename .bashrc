# vim: set ft=zsh:

#region setup {{{
case $- in
  *i*) ;;
    *) return;;
esac

IS_ZSH=
IS_BASH=
if [[ -n "$ZSH_VERSION" ]]; then
  IS_ZSH=1
else
  IS_BASH=1
fi
#endregion setup }}}


#region functions {{{
__have()     { type "$1" &>/dev/null; }
__source_if() { [[ -r "$1" ]] && source "$1"; }
#endregion functions }}}


#region auto-zsh {{{
# Only trigger if:
# - zsh is installed
# - We did not call: bash -c '...'
# - $ZSHSKIP is not set
# - 'zsh' is not the parent process of this shell
if __have zsh && [ "$IS_BASH" ] && [[ -z "$ZSHSKIP" && -z "$BASH_EXECUTION_STRING" && "$(cat /proc/$PPID/comm 2>/dev/null)" != "zsh" ]]; then
  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
  export SHELL=$(command -v zsh)
  exec zsh $LOGIN_OPTION
elif [ "$IS_BASH" ]; then
  export SHELL=$(command -v bash)
fi
#endregion auto-zsh }}}


#region tmux startup {{{
if __have tmux; then
  # keep distrobox instances seperate from host/each other
  export TMUX_TMPDIR="${TERMUX__PREFIX:-}/tmp/tmux${CONTAINER_ID:+-${CONTAINER_ID}}"
  [[ ! -d "$TMUX_TMPDIR" ]] && mkdir -p "$TMUX_TMPDIR"

  # if on a tty, interactive, not already in a tmux session, and TMUXSKIP not set:
  if [[ -t 0 ]] && [[ $- = *i* ]] && [[ -z "$TMUX" ]] && [[ -z "$TMUXSKIP" ]]; then
             # vvv prints tmux sessions in the format `[0/1 (detached/attached)] [timestamp] [id] [session_name]`
    attach=$(tmux 2>/dev/null ls -F \
             '#{session_attached} #{?#{==:#{session_last_attached},},1,#{session_last_attached}} #{session_id} #{s/ /_/:session_name}' \
             |awk '/^0/ {if ($2 > t && $4 !~ /^_/) {t=$2;s=$3}}; END{print s}')
    # ^^^ only auto-reconnect to detached sessions that don't start with _
    if [[ -n "$attach" ]]; then
      out="$(tmux attach -t "$attach")"
    else
      out="$(tmux)"
    fi
    # if original session was exited and not detached, exit
    if [[ "$out" == "[exited]" ]]; then
      exit
    fi
  fi
fi
#endregion tmux startup }}}


#region env {{{
if __have vim; then
  export EDITOR="vim"
else
  export EDITOR="vi"
fi
#endregion env }}}


#region zsh modules {{{
if [ "$IS_ZSH" ]; then
  # redraw and cd functions adapted from https://github.com/romkatv/zsh4humans
  function redraw-prompt() {
    emulate -L zsh
    local f
    for f in chpwd $chpwd_functions precmd $precmd_functions; do
      (( $+functions[$f] )) && $f &>/dev/null
    done
    zle .reset-prompt
    zle -R
  }

  function cd-rotate() {
    emulate -L zsh
    while (( $#dirstack )) && ! pushd -q $1 &>/dev/null; do
      popd -q $1 &>/dev/null
    done
    if (( $#dirstack )); then redraw-prompt; fi
  }
  function cd-back() { cd-rotate +1; }
  function cd-forward() { cd-rotate -0; }
  function cd-up() { cd ..; redraw-prompt; }

  function insert-sudo() { BUFFER="sudo $BUFFER"; zle accept-line; }

  function toggle-comment() {
    if [[ $BUFFER[1] == '#' ]]; then
      if [[ $CURSOR -lt $#BUFFER ]]; then ((CURSOR--)); fi
      BUFFER=$BUFFER[2,-1]
    else
      BUFFER="#$BUFFER"
      ((CURSOR++))
    fi
  }

  autoload -Uz add-zsh-hook
  autoload -U compinit && compinit -u
  zmodload -i zsh/complist
  autoload -U run-help
  autoload -U up-line-or-beginning-search
  autoload -U down-line-or-beginning-search

  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  zle -N cd-forward
  zle -N cd-back
  zle -N cd-up
  zle -N insert-sudo
  zle -N toggle-comment
fi
#endregion zsh modules }}}


#region completion {{{
if [ "$IS_BASH" ] && [ -z "${BASH_COMPLETION_VERSINFO-}" ]; then
  __source_if /usr/share/bash-completion/bash_completion
fi

if [ "$IS_ZSH" ]; then
  zstyle ':completion:*' completer _extensions _complete _correct _approximate
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # colors
  zstyle ':completion:*' rehash true # auto-update PATH
  zstyle ':completion:*' menu select # menu + search completion
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive completion
  zstyle ':completion:*' group-name '' # group matches under descriptions
  zstyle ':completion:*' expand prefix # expand prefix even if last part is ambiguous
  zstyle ':completion:*' list-prompt '' # disable 'do you wish to see all...' prompt
  zstyle ':completion:*:descriptions' format '%B%F{green}━━━━ %d ━━━━%f%b' # format descriptions
fi
#endregion completion }}}


#region readline/keybinds {{{
if [ "$IS_BASH" ]; then
  bind 'set bell-style none'
  bind 'set completion-ignore-case on'          # case-insensitive tab-completion
  bind 'set menu-complete-display-prefix on'    # display partial and menu right away
  bind 'set show-all-if-ambiguous on'           # muptiple possibilities show right away
  bind 'set page-completions off'               # no `more` for tab results
  bind 'set visible-stats on'                   # show filetype characters in completions
  bind 'set colored-stats on'                   # color file/folder completions like ls
  bind 'set mark-symlinked-directories on'      # show / after symlinked directories too

  bind '"\e[A": history-search-backward'        # up arrow
  bind '"\e[B": history-search-forward'         # down arrow
  bind '"\t": menu-complete'                    # tab
  bind '"\e[Z": menu-complete-backward'         # shift-tab
fi

if [ "$IS_ZSH" ]; then
  bindkey -e # EDITOR=vi/vim causes zsh to use vi-mode, so reset that here
  KEYTIMEOUT=1 # escape key timeout to minimum

  # translate between application/raw/TTY codes
  bindkey -s '^[OH' '^[[H'   # home
  bindkey -s '^[[1~' '^[[H'  # home
  bindkey -s '^[OF' '^[[F'   # end
  bindkey -s '^[[4~' '^[[F'  # end
  bindkey -s '^[OA' '^[[A'   # up
  bindkey -s '^[OB' '^[[B'   # down
  bindkey -s '^[OD' '^[[D'   # left
  bindkey -s '^[OC' '^[[C'   # right
  bindkey -s '^[[5~' ''      # do nothing on pageup
  bindkey -s '^[[6~' ''      # do nothing on pagedown

  bindkey '^[[A'    up-line-or-beginning-search          # up arrow
  bindkey '^[[B'    down-line-or-beginning-search        # down arrow
  bindkey '^[[D'    backward-char                        # left
  bindkey '^[[C'    forward-char                         # right
  bindkey '^[[H'    beginning-of-line                    # home
  bindkey '^[[F'    end-of-line                          # end
  bindkey '^?'      backward-delete-char                 # backspace
  bindkey '^[[3~'   delete-char                          # delete
  bindkey '^[[1;5C' forward-word                         # ctrl+right
  bindkey '^[[1;5D' backward-word                        # ctrl+left
  bindkey '^H'      backward-kill-word                   # ctrl+backspace
  bindkey '^[[3;5~' kill-word                            # ctrl+del

  bindkey '^[/'     undo                                 # alt+/

  bindkey '^[[1;3D' cd-back                              # alt+left   cd to prev
  bindkey '^[[1;3C' cd-forward                           # alt+right  cd to next
  bindkey '^[[1;3A' cd-up                                # alt+up     cd ..
  bindkey '^[s'     insert-sudo                          # alt+s      insert 'sudo' and run
  bindkey '^_'      toggle-comment                       # ctrl+/

  bindkey '^[?' run-help                                 # alt+shift+/ (?)
  bindkey -M menuselect '^M'   accept-line               # enter accepts but doesn't run line
  bindkey -M menuselect '+'    accept-and-menu-complete  # + in menu select to add selection
  bindkey -M menuselect '^[[Z' reverse-menu-complete     # shift+tab
  bindkey -M menuselect '^['   send-break                # escape cancels menu
  bindkey -M menuselect '?'    history-incremental-search-forward # ? in menu enters search mode
fi
#endregion readline/keybinds }}}


#region options {{{
if [ "$IS_BASH" ]; then
  shopt -s globstar # ‘**’ matches all files and zero or more directories/subdirectories
  shopt -s dotglob # include .files
  shopt -s extglob # extended pattern matching
fi

if [ "$IS_ZSH" ]; then
  setopt autocd # if cmd fails and is name of folder, cd into folder
  setopt autopushd # make cd push old directory onto directory stack
  setopt completeinword # cursor stays in place and completion is done from both ends
  setopt correct # try to correct the spelling of commands
  setopt extendedglob # treat ‘#’/‘~’/‘^’ characters as part of patterns
  setopt interactivecomments # allow comments in interactive shells
  setopt extendedhistory # save each command’s beginning timestamp and duration
  setopt incappendhistory # appends commands to history immediately
  setopt histignorealldups # remove older duplicates
  setopt histignorespace # remove from history when first character is a space
  setopt listpacked # vary column widths for more compact menu
  setopt nobeep # don't beep on error
  setopt nohup # don't HUP background jobs
  setopt noautoremoveslash # keep trailing slash
  setopt nolistambiguous # show list immediately when ambiguous matches
fi
#endregion options }}}


#region history {{{
if [ "$IS_BASH" ]; then
  HISTCONTROL=ignoreboth
  HISTSIZE=10000
  HISTFILESIZE=10000

  shopt -s histappend
fi

if [ "$IS_ZSH" ]; then
  HISTFILE=~/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
fi
#endregion history }}}


#region path {{{
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
#endregion path }}}


#region colors {{{
__have dircolors && eval "$(dircolors -b)"

BLACKFG=$'\e[30m'    REDFG=$'\e[31m'       GREENFG=$'\e[32m'    YELLOWFG=$'\e[33m'
BLUEFG=$'\e[34m'     PURPLEFG=$'\e[35m'    CYANFG=$'\e[36m'     WHITEFG=$'\e[37m'
BRBLACKFG=$'\e[90m'  BRREDFG=$'\e[91m'     BRGREENFG=$'\e[92m'  BRYELLOWFG=$'\e[93m'
BRBLUEFG=$'\e[94m'   BRPURPLEFG=$'\e[95m'  BRCYANFG=$'\e[96m'   BRWHITEFG=$'\e[97m'

BLACKBG=$'\e[40m'    REDBG=$'\e[41m'       GREENBG=$'\e[42m'    YELLOWBG=$'\e[43m'
BLUEBG=$'\e[44m'     PURPLEBG=$'\e[45m'    CYANBG=$'\e[46m'     WHITEBG=$'\e[47m'
BRBLACKBG=$'\e[100m' BRREDBG=$'\e[101m'    BRGREENBG=$'\e[102m' BRYELLOWBG=$'\e[103m'
BRBLUEBG=$'\e[104m'  BRPURPLEBG=$'\e[105m' BRCYANBG=$'\e[106m'  BRWHITEBG=$'\e[107m'

BOLD=$'\e[1m' RESET=$'\e[0m'
#endregion colors }}}


#region common prompt {{{
COLORBARS1="${BRREDBG} ${BRYELLOWBG} ${BRGREENBG} ${BRCYANBG} ${RESET}"
COLORBARS2="${BRCYANBG} ${BRBLUEBG} ${RESET}"

NEWLINE=$'\n'

__common_prompt() {
  # statuscolor
  exitstatus=$?
  statuscolor="${BRCYANFG}"
  [[ ${exitstatus} != 0 ]] && statuscolor="${BRREDFG}"

  # pwd
  pwd=${PWD/#$HOME/'~'}
  pwd=${pwd/#\/var$HOME/'~'}
  if [[ -O ${PWD} ]]; then # owned
    pwd="${BRGREENFG}${pwd}${RESET}"
  elif [[ -w ${PWD} ]]; then # writable
    pwd="${BRCYANFG}${pwd}${RESET}"
  else # read-only
    pwd="${BRREDFG}${pwd}${RESET}"
  fi

  # git branch/status
  branch=$(git branch --show-current 2>/dev/null)
  if [[ -n "${branch}" ]]; then
    dirty=
    col="${BRGREENFG}"
    [[ ${branch} == main || ${branch} == master ]] && col="${BRREDFG}"
    if [[ -n "$(git status --porcelain -uno 2>/dev/null)" ]]; then
      dirty="+"
    fi
    branch="${WHITEFG}(${BOLD}${col}${branch}${BRWHITEFG}${BOLD}${dirty}${RESET}${WHITEFG})${RESET}"
  fi

  # python venv
  venv=${VIRTUAL_ENV##*/}
  [[ -n "$venv" ]] && venv="${WHITEFG}(${BOLD}${BRCYANFG}${venv}${RESET}${WHITEFG})${RESET}"

  # user@host text
  ctr="${CONTAINER_ID:+${CONTAINER_ID}.}"
  userhoststr="\u@${ctr}\H"
  [ "$IS_ZSH" ] && userhoststr="%n@${ctr}%M"

  # distrobox prompt color change
  if [ -f /run/.containerenv ] || [ -f /.dockerenv ]; then
    userhost="${RESET}${BRBLACKBG}${BRWHITEFG} ${userhoststr} ${RESET}"
  else
    userhost="${RESET}${BRWHITEBG}${BLACKFG} ${userhoststr} ${RESET}"
  fi
}
#endregion common prompt }}}


#region bash prompt {{{
if [ "$IS_BASH" ]; then
  __bash_prompt() {
    __common_prompt
    line1="${statuscolor}╔${RESET} ${COLORBARS1}${userhost}${COLORBARS2} ${pwd} ${branch}${venv}"
    line2="\[${statuscolor}\]╚═\[${RESET}\] "
    PS1="${RESET}${NEWLINE}${line1}${NEWLINE}${line2}"
  }
  PROMPT_COMMAND="__bash_prompt"
fi
#endregion bash prompt }}}


#region zsh prompt {{{
if [ "$IS_ZSH" ]; then
  __zsh_prompt() {
    __common_prompt
    line1="%{${statuscolor}┏${RESET} ${COLORBARS1}${userhost}${COLORBARS2} ${pwd} ${branch}${venv}%}"
    line2="%2{${statuscolor}┗━${RESET}%} "
    PROMPT="${RESET}${NEWLINE}${line1}${NEWLINE}${line2}"
  }

  add-zsh-hook precmd __zsh_prompt
fi
#endregion zsh prompt }}}


#region manpage colors {{{
export LESS_TERMCAP_mb="${BOLD}${REDFG}"              # begin bold
export LESS_TERMCAP_md="${BOLD}${CYANFG}"             # begin blink
export LESS_TERMCAP_me="${RESET}"                     # reset bold/blink
export LESS_TERMCAP_so="${BOLD}${BLUEBG}${YELLOWFG}"  # begin reverse video
export LESS_TERMCAP_se="${RESET}"                     # reset reverse video
export LESS_TERMCAP_us="${BOLD}${GREENFG}"            # begin underline
export LESS_TERMCAP_ue="${RESET}"                     # reset underline
#endregion manpage colors }}}


#region less options {{{
# -a: skip search results on same screen
# -q: no bell
# -F: just print file if it fits on screen
# -R: allow escape characters through
# -X: don't clear screen
[[ $(less --version 2>/dev/null |grep -E "less [0-9]+" |cut -d " " -f 2) -ge 543 ]] && mouse='--mouse --wheel-lines 3'
export LESS="$mouse -aqFRX"
#endregion less options }}}


#region aliases/functions {{{
[ "$IS_BASH" ] && alias brl='exec bash'
[ "$IS_ZSH" ] && alias zrl='exec zsh'

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

alias sshre='TERM=${TERM}-tmux-re ssh'
alias sshno='TERM=${TERM}-tmux-no ssh'
alias sshl='ssh -oKexAlgorithms=+diffie-hellman-group1-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1 \
            -oHostKeyAlgorithms=+ssh-rsa -oCiphers=+aes128-ctr,aes128-cbc -oPubkeyAcceptedKeyTypes=+ssh-rsa -oRequiredRSASize=1024'

alias dotup='(cd ~/.dotfiles && git pull && ./setup)'

# q (quiet) runs commands disconnected from current term and without stdout/stderr (browser, file explorer)
function q() { (nohup "$@" &>/dev/null &); }

if __have eza; then
  if eza -v |grep -q '+git'; then git='--git'; fi
  alias ls='eza'
  alias l="eza -lg ${git}"
  alias ll="eza -lag ${git}"
elif __have exa; then
  if exa -v |grep -q '+git'; then git='--git'; fi
  alias ls='exa'
  alias l="exa -lg ${git}"
  alias ll="exa -lag ${git}"
else
  alias ls='command ls -vF --color=auto'
  alias l='ls -l'
  alias ll='ls -lhA'
fi

if __have bat; then
  alias cat='bat --theme=ansi --style=grid,header,header-filesize'
fi

if __have vim; then
  alias vi='vim'
fi

if __have python; then
  pyv() { python -m venv "${1:-.venv}"; }
  pya() { source "${1:-.venv}/bin/activate"; }
  alias pyd='__have deactivate && deactivate'
fi

if __have apt; then
  alias apt='sudo apt'
fi

if __have dnf; then
  alias dnf='sudo dnf'
fi

if __have apk; then
  alias apk='sudo apk'
fi

if __have pacman; then
  alias pacman='sudo pacman'
fi

if __have yay; then
  alias yay='yay --color always --cleanmenu=false --diffmenu=false --editmenu=false'
fi

if __have paru; then
  alias paru='paru --skipreview --bottomup'
fi

if __have flatpak; then
  alias fp='flatpak'
fi

if __have systemctl; then
  alias sc='sudo systemctl'
  alias scdr='sudo systemctl daemon-reload'
  alias scu='systemctl --user'
  alias scudr='systemctl --user daemon-reload'
fi

if __have journalctl; then
  alias jc='sudo journalctl'
  alias jcu='journalctl --user'
fi

if __have docker; then
  alias d='docker'
  alias dc='docker compose'
  alias dps='docker ps'
  alias dpsa='docker ps -a'
  alias dx='docker exec -it'
  alias dr='docker run -it'
  alias drm='docker run -it --rm'
  alias dl='docker logs'
  alias dlf='docker logs -f'
  alias dlfs='docker logs -f --since'
fi

if __have podman; then
  alias p='podman'
  alias pps='podman ps'
  alias ppsa='podman ps -a'
  alias px='podman exec -it'
  alias pr='podman run -it'
  alias prm='podman run -it --rm'
  alias pun='podman unshare'
  alias pl='podman logs'
  alias plf='podman logs -f'
  alias plfs='podman logs -f --since'
fi

if __have distrobox; then
  alias db='distrobox'
  alias dbe='distrobox enter'
fi

if __have distrobox-export; then
  alias dbex='distrobox-export'
fi

if __have distrobox-host-exec; then
  function dbh() {
    if [[ -z ${@:+x} ]]; then
      distrobox-host-exec sh -c 'exec $SHELL'
    else
      distrobox-host-exec "$@"
    fi
  }
fi
#endregion aliases/functions }}}
