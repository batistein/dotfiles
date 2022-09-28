#!/bin/sh
if  command -v kubectl krew >/dev/null 2>&1; then 
    echo "krew already installed"
else
  curl https://krew.sh/ | bash

fi