#!/bin/bash

orig="$1"
new="$2"

if [ -z "$orig" -o -z "$new" ]; then
	echo "Source and Destination needed!"
	exit
fi

if [ -d "$new" ]; then
	new="$new/$(basename $orig)"
fi
#mkdir -p "$(dirname $new)"

mv "$orig" "$new"

ln -sf "$(cd $(dirname $new) && pwd)/$(basename $new)" "$orig"
