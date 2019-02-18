#!/bin/bash

dotdir=$(cd $(dirname "$0")/.. && pwd)

homedir=~

cd $dotdir
for file in $(find . -path ./.git -prune -o \( -type f ! -name README.md \) -type f -print |cut -c3-); do
	filedir=$(dirname $file)
	mkdir -p ~/$filedir
	ln -sf $(pwd)/$file ~/$filedir
	#echo file: $file
	#echo base: $(basename $file)
	#echo dirn: $(dirname $file)
done
