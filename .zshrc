# User .zshrc
case $- in *i*)
	if [ -z "$TMUX" ]; then
		if [ -z $DISPLAY ]; then
			#on console, don't destroy detached, don't exec
			tmux new
		else
			#in gui terminal, kill detached automatically if window closes
			exec tmux new \; set-option destroy-unattached
		fi
	fi;
esac
