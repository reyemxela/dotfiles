#!/bin/bash

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

xset r rate 300 50
xset s 3600 3600 dpms 3600 3600 3600

compton &
autorandr -c --force
~/bin/setbg &


[ -f ~/bin/dwmstatus ] && while true; do
    ~/bin/dwmstatus
    sleep 1
done &

while true; do
    dwm
done
#exec i3
#exec bspwm
#exec awesome
#exec startxfce4
