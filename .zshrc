#!/usr/bin/zsh
#zstyle ':prompt:grml:left:setup' items user at host path newline percent

[ -f ~/.aliasrc ] && . ~/.aliasrc

export PATH="$PATH:$HOME/bin/"


# prompt stuff
if [ ! -z $DISPLAY ]; then
    separator=""
    separator2=""
    computer=""
    folder=""
fi
nobg="%k"
bg0="%K{0}"
bg1="%K{1}"
bg2="%K{2}"
bg3="%K{3}"
bg4="%K{4}"
bg5="%K{5}"
bg6="%K{6}"
bg7="%K{7}"

nofg="%f"
fg0="%F{0}"
fg1="%F{1}"
fg2="%F{2}"
fg3="%F{3}"
fg4="%F{4}"
fg5="%F{5}"
fg6="%F{6}"
fg7="%F{7}"

bold="%B"
unbold="%b"

user="%n"
host="%m"

PS1="$bg7$fg4$bold$user$nofg$nobg$unbold$bg3$fg7$separator$nofg $computer $host$nobg$fg3$separator$nofg $folder $bold%40<..<%~%<< $unbold
$bg7$fg4%# $nofg$nobg$fg7$separator2$nofg "


# history
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000


# completion stuff
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
# case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# modules
autoload -U compinit && compinit
zmodload -i zsh/complist
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# options
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


# keybindings
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char
bindkey "${terminfo[kich1]}" quoted-insert
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
