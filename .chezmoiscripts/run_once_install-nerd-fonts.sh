#!/bin/sh
if  [ "$(ls -A ~/.nerd-fonts)" ]; then 
    echo "nerd-font already installed"
else
(
    git clone --depth=1 https://github.com/ryanoasis/nerd-fonts ~/.nerd-fonts
    cd .nerd-fonts 
    sudo ./install.sh
)
fi