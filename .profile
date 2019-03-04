#!/bin/bash

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && $(which startx >/dev/null); then exec startx; fi

[ -f ~/.config/_colorschemes/tty_config ] && source ~/.config/_colorschemes/tty_config
