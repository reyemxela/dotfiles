#!/bin/bash

if command -v exa >/dev/null 2>&1; then
    alias l="command exa -l"
    alias ls="command exa"
    alias la="command exa -laa"
    alias ll="command exa -la"
else
    alias l="command ls -lF -v --color=auto"
    alias ls="command ls -vF --color=auto"
    alias la="command ls -laF -v --color=auto"
    alias ll="command ls -lhAF -v --color=auto"
fi

alias xc="xclip -in -selection clipboard"
alias wifi-menu="sudo wifi-menu"
alias ssh="TERM=xterm ssh"
alias wgup="sudo wg-quick up wg0"
alias wgdown="sudo wg-quick down wg0"

source /etc/os-release

case "$ID" in
    void)
        alias xbs="xbps-query -Rs"
        alias xbi="sudo xbps-install"
        alias xbr="sudo xbps-remove"
        alias xbu="sudo xbps-install -Su"
        alias sv="sudo sv"

        sve() { [ "$1" != "" ] && sudo ln -s /etc/sv/$1 /var/service/; }
        svd() { [ -h /var/service/$1 ] && sudo unlink /var/service/$1; }
        ;;
    *)
        alias scr="sudo systemctl restart"
        alias scs="sudo systemctl start"
        alias scst="sudo systemctl stop"
        ;;
esac
