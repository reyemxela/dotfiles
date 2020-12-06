#!/bin/bash

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi


###############################

function _common_wm {
    xset r rate 300 50
    xset s 3600 3600 dpms 3600 3600 3600

    compton &
    autorandr -c --force
    ~/bin/setbg &
}


function _dwm {
    _common_wm
    [ -f ~/bin/dwmstatus ] && while true; do
        ~/bin/dwmstatus
        sleep 1
    done &

    while true; do
        dwm
    done
}


function _kde {
    exec startplasma-x11
}


###############################

_kde
