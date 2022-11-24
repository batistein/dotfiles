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

check_buildx_installed() {
  # If buildx is not available on the path, get it
  if ! [ -x "$(command -v buildx)" ]; then
    echo 'buildx not found, installing'
    install_buildx
  fi
}

verify_buildx_version() {

  local buildx_version
  buildx_version="$(docker buildx version | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"
  if [[ "${MINIMUM_BUILDX_VERSION}" != $(echo -e "${MINIMUM_BUILDX_VERSION}\n${buildx_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected buildx version: ${buildx_version}.
Requires ${MINIMUM_BUILDX_VERSION} or greater.
Please install ${MINIMUM_BUILDX_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing buildx' && install_buildx
  else
    cat <<EOF
Detected buildx version: ${buildx_version}.
Requires ${MINIMUM_BUILDX_VERSION} or greater.
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

install_buildx() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -sLo "buildx" https://github.com/docker/buildx/releases/download/v${MINIMUM_BUILDX_VERSION}/buildx-v${MINIMUM_BUILDX_VERSION}.linux-amd64
      copy_binary
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -sLo "buildx" https://github.com/docker/buildx/releases/download/v${MINIMUM_BUILDX_VERSION}/buildx-v${MINIMUM_BUILDX_VERSION}.darwin-amd64
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
      mv buildx "$HOME/.local/bin/buildx"
      chmod +x "$HOME/.local/bin/buildx"
  else
      echo "Installing buildx to /usr/local/bin which is write protected"
      echo "If you'd prefer to install buildx without sudo permissions, add \$HOME/.local/bin to your \$PATH and rerun the installer"
      sudo mv buildx /usr/local/bin/buildx
      chmod +x "/usr/local/bin/buildx"
  fi
  echo "Installation Finished"
}

check_buildx_installed "$@"
verify_buildx_version "$@"


# TODO Krew Plugin support and buildx plugins: argocd rollout