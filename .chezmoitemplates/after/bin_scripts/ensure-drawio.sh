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

check_drawio_installed() {
  # If drawio is not available on the path, get it
  if ! [ -x "$(command -v drawio)" ]; then
    echo 'drawio not found, installing'
    install_drawio
  fi
}


verify_drawio_version() {

  local drawio_version
  drawio_version="$(rpm -q draw.io | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}" )"
  if [[ "${MINIMUM_DRAWIO_VERSION}" != $(echo -e "${MINIMUM_DRAWIO_VERSION}\n${drawio_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected drawio version: ${drawio_version}.
Requires ${MINIMUM_DRAWIO_VERSION} or greater.
Please install ${MINIMUM_DRAWIO_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing DRAWIO' && install_drawio
  else
    cat <<EOF
Detected drawio version: ${drawio_version}.
Requires ${MINIMUM_DRAWIO_VERSION} or greater.
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

install_drawio() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -L https://github.com/jgraph/drawio-desktop/releases/download/v${MINIMUM_DRAWIO_VERSION}/drawio-x86_64-${MINIMUM_DRAWIO_VERSION}.rpm -o drawio.rpm
      install_dnf
    else
      set +x
      echo "The installer does not work for your platform: $OSTYPE"
      exit 1
    fi

}

function install_dnf() {
  sudo rpm -i drawio.rpm --excludepath /usr/lib/.build-id/
  sudo rm -rf drawio.rpm
  echo "Installation Finished"
}

check_drawio_installed "$@"
verify_drawio_version "$@"