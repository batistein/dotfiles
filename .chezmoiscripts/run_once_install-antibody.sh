#!/bin/sh
if  command -v antibody >/dev/null 2>&1; then 
	echo "antibody already installed"
else
curl -sL https://git.io/antibody | sudo sh -s -- -b /usr/local/bin
fi
