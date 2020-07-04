#!/bin/bash

for env in $(ls -I create_links.sh)
do
	ln -s "$PWD/$env" "$HOME/.config/$env" 2>/dev/null
	if [ $? -ne 0 ]; then
		echo "A symlink already exists for $env"
	else
		echo "Created link for $env"
	fi
done
