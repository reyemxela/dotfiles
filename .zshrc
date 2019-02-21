#!/usr/bin/zsh
#zstyle ':prompt:grml:left:setup' items user at host path newline percent

[ -f ~/.aliasrc ] && . ~/.aliasrc

export PATH="$PATH:$HOME/bin/"
export EDITOR=vim

dircolors &>/dev/null && eval `dircolors`

# prompt stuff {{{
computer="@"
fc-list 2>/dev/null|grep -qi "nerd" && fontavailable=true
if [ ! -z $DISPLAY ] && [ $fontavailable ]; then
    computer=" "
    folder="  "
    #separator1=""
    #separator2=""
fi
separator1="▉▊▋▌▍▎▏"
separator2="▏▎▍▌▋▊▉"

if [ ${EUID} -eq 0 ]; then
    accentcolor=1
else
    accentcolor=$[${RANDOM}%5+2]
fi

accentfg="%F{$accentcolor}"
accentbg="%K{$accentcolor}"

maincolor=7

mainfg="%F{$maincolor}"
mainbg="%K{$maincolor}"

bg0="%K{0}" bg1="%K{1}" bg2="%K{2}" bg3="%K{3}"
bg4="%K{4}" bg5="%K{5}" bg6="%K{6}" bg7="%K{7}"

fg0="%F{0}" fg1="%F{1}" fg2="%F{2}" fg3="%F{3}"
fg4="%F{4}" fg5="%F{5}" fg6="%F{6}" fg7="%F{7}"

nobg="%k" nofg="%f"
bold="%B" unbold="%b"

user="%n"
host="%m"

usersection="$mainbg$fg0$bold $user$nofg$nobg$unbold"
hostsection="$accentbg$fg0$computer$host $nobg$nofg"
pathsection="$nobg$mainfg$folder$bold%40<..<%~%<<$unbold$nofg$nobg"

line1="$mainfg╭─$separator2$usersection$mainfg$accentbg$separator1 $hostsection$accentfg$separator1$pathsection"
line2="$mainfg╰─╼$nofg "

PS1="$line1"$'\n'"$line2"

# }}}

# history {{{
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# }}}

# completion stuff {{{
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
bindkey '\e.' insert-last-word
# + in menu select to add on:
bindkey -M menuselect "+" accept-and-menu-complete
# }}}

# custom functions/hooks {{{
chpwd () { pwd | toilet -t -f smblock 2>/dev/null || echo "[ $(pwd) ]\n"; ls -FC; }
preexec () { print -Pn "\e]2;$1\a" }
precmd () { print -Pn "\e]2;$PWD\a" }
# }}}
