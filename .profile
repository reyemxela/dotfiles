#!/bin/bash

if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && $(which startx >/dev/null); then exec startx; fi

[ -f ~/.config/_colorschemes/colors-tty.sh ] && . ~/.config/_colorschemes/colors-tty.sh
