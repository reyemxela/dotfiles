#!/usr/bin/zsh
zstyle ':prompt:grml:left:setup' items user at host path newline percent

[ -f ~/.aliasrc ] && . ~/.aliasrc

export TERMINAL="urxvt"
export EDITOR="vim"
export FILE="ranger"
export PATH="$PATH:$HOME/bin/"
