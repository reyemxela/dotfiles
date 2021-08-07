#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


if [ ${EUID} -eq 0 ]; then
    accentcolor=1
else
    accentcolor=$[${RANDOM}%5+2]
fi
accentcolor="\[$(tput setaf $accentcolor)\]"
bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

PS1="[${bold}\u@${accentcolor}\h${reset}] \W \$ "

[ -f ~/.envrc ] && source ~/.envrc
