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

check_cilium_installed() {
  # If cilium is not available on the path, get it
  if ! [ -x "$(command -v cilium)" ]; then
    echo 'cilium not found, installing'
    install_cilium
  fi
}


verify_cilium_version() {

  local cilium_version
  cilium_version="$(cilium version | grep "cilium-cli" | awk '{print $2}' | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"
  if [[ "${MINIMUM_CILIUM_VERSION}" != $(echo -e "${MINIMUM_CILIUM_VERSION}\n${cilium_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected cilium version: ${cilium_version}.
Requires ${MINIMUM_CILIUM_VERSION} or greater.
Please install ${MINIMUM_CILIUM_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing CILIUM' && install_cilium
  else
    cat <<EOF
Detected cilium version: ${cilium_version}.
Requires ${MINIMUM_CILIUM_VERSION} or greater.
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

install_cilium() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -fsSL https://github.com/cilium/cilium-cli/releases/download/v${MINIMUM_CILIUM_VERSION}/cilium-linux-amd64.tar.gz | tar -xzv cilium
      copy_binary
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -fsSL https://github.com/cilium/cilium-cli/releases/download/v${MINIMUM_CILIUM_VERSION}/cilium-darwin-amd64.tar.gz | tar -xzv cilium
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
      mv cilium "$HOME/.local/bin/cilium"
      chmod +x "$HOME/.local/bin/cilium"
  else
      echo "Installing CILIUM to /usr/local/bin which is write protected"
      echo "If you'd prefer to install CILIUM without sudo permissions, add \$HOME/.local/bin to your \$PATH and rerun the installer"
      sudo mv cilium /usr/local/bin/cilium
      chmod +x "/usr/local/bin/cilium"
  fi
  echo "Installation Finished"
}

check_cilium_installed "$@"
verify_cilium_version "$@"