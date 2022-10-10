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

check_istioctl_installed() {
  # If istioctl is not available on the path, get it
  if ! [ -x "$(command -v istioctl)" ]; then
    echo 'istioctl not found, installing'
    install_istioctl
  fi
}


verify_istioctl_version() {

  local istioctl_version
  istioctl_version="$(istioctl version -s | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"
  if [[ "${MINIMUM_ISTIOCTL_VERSION}" != $(echo -e "${MINIMUM_ISTIOCTL_VERSION}\n${istioctl_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected istioctl version: ${istioctl_version}.
Requires ${MINIMUM_ISTIOCTL_VERSION} or greater.
Please install ${MINIMUM_ISTIOCTL_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing ISTIOCTL' && install_istioctl
  else
    cat <<EOF
Detected istioctl version: ${istioctl_version}.
Requires ${MINIMUM_ISTIOCTL_VERSION} or greater.
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

install_istioctl() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -fsSL https://github.com/istio/istio/releases/download/${MINIMUM_ISTIOCTL_VERSION}/istioctl-${MINIMUM_ISTIOCTL_VERSION}-linux-amd64.tar.gz | tar -xzv istioctl
      copy_binary
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -fsSL https://github.com/istio/istio/releases/download/${MINIMUM_ISTIOCTL_VERSION}/istioctl-${MINIMUM_ISTIOCTL_VERSION}-linux-amd64.tar.gz | tar -xzv istioctl
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
      mv istioctl "$HOME/.local/bin/istioctl"
      chmod +x "$HOME/.local/bin/istioctl"
  else
      echo "Installing ISTIOCTL to /usr/local/bin which is write protected"
      echo "If you'd prefer to install ISTIOCTL without sudo permissions, add \$HOME/.local/bin to your \$PATH and rerun the installer"
      sudo mv istioctl /usr/local/bin/istioctl
      chmod +x "/usr/local/bin/istioctl"
  fi
  echo "Installation Finished"
}

check_istioctl_installed "$@"
verify_istioctl_version "$@"