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

check_yq_installed() {
  # If yq is not available on the path, get it
  if ! [ -x "$(command -v yq)" ]; then
    echo 'yq not found, installing'
    install_yq
  fi
}


verify_yq_version() {

  local yq_version
  yq_version="$(yq --version | awk '{print $4}' |  grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"
  if [[ "${MINIMUM_YQ_VERSION}" != $(echo -e "${MINIMUM_YQ_VERSION}\n${yq_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected yq version: ${yq_version}.
Requires ${MINIMUM_YQ_VERSION} or greater.
Please install ${MINIMUM_YQ_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing YQ' && install_yq
  else
    cat <<EOF
Detected yq version: ${yq_version}.
Requires ${MINIMUM_YQ_VERSION} or greater.
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

install_yq() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -sLo "yq" https://github.com/mikefarah/yq/releases/download/v${MINIMUM_YQ_VERSION}/yq_linux_amd64
      copy_binary
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -sLo "yq" https://github.com/mikefarah/yq/releases/download/v${MINIMUM_YQ_VERSION}/yq_darwin_amd64
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
      mv yq "$HOME/.local/bin/yq"
      chmod +x "$HOME/.local/bin/yq"
  else
      echo "Installing YQ to /usr/local/bin which is write protected"
      echo "If you'd prefer to install YQ without sudo permissions, add \$HOME/.local/bin to your \$PATH and rerun the installer"
      sudo mv yq /usr/local/bin/yq
      chmod +x "/usr/local/bin/yq"
  fi
  echo "Installation Finished"
}

check_yq_installed "$@"
verify_yq_version "$@"