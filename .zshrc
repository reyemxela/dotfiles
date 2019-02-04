# User .zshrc
case $- in *i*)
	if [ -z "$TMUX" ]; then
		if [ -z $DISPLAY ]; then
			#on console, don't destroy detached, don't exec
			tmux new
		else
			#in gui terminal, kill detached automatically if window closes
			#exec tmux new \; set-option destroy-unattached
		fi
	fi;
esac

alias ls="command ls -v --color=auto"
alias la="command ls -la -v --color=auto"
alias ll="command ls -lhAF -v --color=auto"
alias l="command ls -l -v --color=auto"
alias xc='xclip -in -selection clipboard'

