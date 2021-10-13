#!/bin/bash

for env in $(ls -I create_links.sh -I README.md)
do
	target="$HOME/.config/$env"
	if [ -f ${target} ] || [ -L ${target} ]; then
		echo "file $env already exists on target dir. Ignoring."
	else
		ln -s "$PWD/$env" "$HOME/.config/$env" 2>/dev/null
		echo "Created link for $env"
	fi
done
