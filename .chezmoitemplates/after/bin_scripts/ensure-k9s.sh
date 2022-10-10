#!/usr/bin/env bash

# Copyright 2022 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

check_k9s_installed() {
  # If k9s is not available on the path, get it
  if ! [ -x "$(command -v k9s)" ]; then
    echo 'k9s not found, installing'
    install_k9s
  fi
}


verify_k9s_version() {

  local k9s_version
  k9s_version="$(k9s version -s | grep "Version" | awk '{print $2}' | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"
  if [[ "${MINIMUM_K9S_VERSION}" != $(echo -e "${MINIMUM_K9S_VERSION}\n${k9s_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected k9s version: ${k9s_version}.
Requires ${MINIMUM_K9S_VERSION} or greater.
Please install ${MINIMUM_K9S_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing K9S' && install_k9s
  else
    cat <<EOF
Detected k9s version: ${k9s_version}.
Requires ${MINIMUM_K9S_VERSION} or greater.
Nothing to do!

EOF
  fi
}

confirm() {
    # call with a prompt string or use a default
    echo "${1:-Do you want to install? [y/N]}"
    read -r -p "" response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            return 2
            ;;
    esac
}

install_k9s() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -fsSL https://github.com/derailed/k9s/releases/download/v${MINIMUM_K9S_VERSION}/k9s_Linux_x86_64.tar.gz | tar -xzv k9s
      copy_binary
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -fsSL https://github.com/derailed/k9s/releases/download/v${MINIMUM_K9S_VERSION}/k9s_Darwin_x86_64.tar.gz | tar -xzv k9s
      copy_binary
    else
      set +x
      echo "The installer does not work for your platform: $OSTYPE"
      exit 1
    fi

}

function copy_binary() {
  if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
      if [ ! -d "$HOME/.local/bin" ]; then
        mkdir -p "$HOME/.local/bin"
      fi
      mv k9s "$HOME/.local/bin/k9s"
      chmod +x "$HOME/.local/bin/k9s"
  else
      echo "Installing K9S to /usr/local/bin which is write protected"
      echo "If you'd prefer to install K9S without sudo permissions, add \$HOME/.local/bin to your \$PATH and rerun the installer"
      sudo mv k9s /usr/local/bin/k9s
      chmod +x "/usr/local/bin/k9s"
  fi
  echo "Installation Finished"
}

check_k9s_installed "$@"
verify_k9s_version "$@"