#!/usr/bin/zsh

function _installed {
    command -v "$1" >/dev/null 2>&1
    return $?
}

[ -f ~/.config/_shell/env.sh ]     && source ~/.config/_shell/env.sh
[ -f ~/.config/_shell/aliases.sh ] && source ~/.config/_shell/aliases.sh

export PATH="$HOME/bin:$HOME/.local/bin:$PATH:/opt/metasploit-framework/bin"
export EDITOR=vim

_installed dircolors && eval `dircolors`

# prompt stuff {{{
_installed fc-list && { fc-list 2>/dev/null|grep -qi "nerd" && fontavailable=true }

computer="@"
arrowline1="┌─"
arrowline2="└──"
if [ ! -z $DISPLAY ]; then
    if [ $fontavailable ]; then
        computer=" "
        folder="  "
        #separator1=""
        #separator2=""
    fi
    arrowline1="╭─"
    arrowline2="╰─╼"
fi
#separator1="▉▊▋▌▍▎▏"
#separator2="▏▎▍▌▋▊▉"
separator1="▓▒░ "
separator2=" ░▒▓"

if [ ${EUID} -eq 0 ]; then
    accentcolor=1
    # red for root
else
    accentcolor=$[${RANDOM}%5+2]
    # random colors (except red)  for user
fi
accentfg="%F{$accentcolor}" accentbg="%K{$accentcolor}"

maincolor="white"
mainfg="%F{$maincolor}" mainbg="%K{$maincolor}"

textfg="%F{black}"

nobg="%k" nofg="%f"
bold="%B" unbold="%b"

user="%n"
host="%m"
newline=$'\n'

usersection="$mainbg$textfg$bold $user $nofg$nobg$unbold"
hostsection="$accentbg$textfg$computer$host $nobg$nofg"
pathsection="$nobg$mainfg$folder$bold%40<..<%~%<<$unbold$nofg$nobg"

line1="$mainfg$arrowline1$separator2$usersection$mainfg$accentbg$separator1$hostsection$accentfg$separator1$pathsection"
line2="%{$mainfg%}$arrowline2%{$nofg%} "

PS1="$line1${newline}$line2"

# }}}

# history {{{
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# }}}

# completion stuff {{{
fpath=(~/.zfunc $fpath)

# persistent rehash
zstyle ':completion:*' rehash true
# menu selection
zstyle ':completion:*' menu select
# color in completion
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _complete
# case-insensitive completion
zstyle ':completion:*' matcher-list '' '+m:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
# }}}

# modules {{{
autoload -U compinit && compinit
zmodload -i zsh/complist
#autoload -Uz predict-on
autoload -U run-help
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
#zle -N predict-on && predict-on
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# }}}

# options {{{
setopt autocd
setopt append_history
setopt autopushd
setopt nobeep
setopt completeinword
setopt correct
setopt extendedglob
setopt extendedhistory
setopt histignorealldups
setopt histignorespace
setopt nohup
setopt interactive
setopt interactivecomments
setopt longlistjobs
setopt monitor
setopt pushdignoredups
setopt sharehistory
# }}}

# custom functions {{{
cdUndo() {
    echo
    cd "$OLDPWD"
    zle reset-prompt
    echo
}
cdParent() {
    echo
    cd ..
    zle reset-prompt
    echo
}

zle -N cdUndo
zle -N cdParent
# }}}

# keybindings {{{
# partial word search:
bindkey "\e[A" up-line-or-beginning-search
bindkey "\e[B" down-line-or-beginning-search
# home/end stuff:
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "${terminfo[kdch1]}" delete-char
bindkey "${terminfo[kich1]}" quoted-insert
# ctrl+arrows to move back/forward whole words:
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
# escape+./meta+. to insert last word. not sure how it broke.
bindkey "\e." insert-last-word
# + in menu select to add on:
bindkey -M menuselect "+" accept-and-menu-complete
# remove double-escape/pageup/pagedn for vi-mode:
bindkey -r "\e"
# run-help
bindkey "\eh" run-help
# custom functions
bindkey "\e[1;3D" cdUndo
bindkey "\e[1;3A" cdParent
# }}}

# hook functions {{{
chpwd () { (_installed toilet && { pwd | toilet -t -f smblock 2>/dev/null } || echo "[ $(pwd) ]\n") && ls; }

set_title () { print -rn $'\e]0;'${${:-${(%):-$1}$2}//[^[:print:]]/_}$'\a' }
preexec () { set_title "$1" }
precmd () { set_title "$PWD" }
# }}}
