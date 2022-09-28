#!/bin/bash
if  [ "$(ls -A ~/.tmux/plugins/tpm/)" ]
then
        echo "tpm already installed"
else
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

