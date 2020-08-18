#!/bin/sh
if command -v kubectl krew >/dev/null 2>&1; then 
    kubectl krew install mtail
    kubectl krew install np-viewer
    kubectl krew install get-all
    kubectl krew install kubesec-scan
    kubectl krew install images
else
    ./run_once_install-krew.sh
fi

if command -v kubectl df-pv > /dev/null 2>&1; then 
    echo "df-pv already installed"
else
    curl https://krew.sh/df-pv | bash
fi