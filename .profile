#!/bin/sh

# startx if on tty1 and have startx
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && $(which startx >/dev/null); then exec startx; fi

# if on console (checked in config), make nice tty colors
[ -f ~/.config/_colorschemes/tty_config ] && source ~/.config/_colorschemes/tty_config

[ -f ~/.aliasrc ] && source ~/.aliasrc
