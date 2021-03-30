#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

[ -f ~/.config/_shell/aliases.sh ] && source ~/.config/_shell/aliases.sh
[ -f ~/.config/_shell/env.sh ]     && source ~/.config/_shell/env.sh
