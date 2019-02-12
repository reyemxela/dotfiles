#!/bin/bash

if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]; then exec startx; fi

[ -f ~/.cache/wal/colors-tty.sh ] && . ~/.cache/wal/colors-tty.sh
