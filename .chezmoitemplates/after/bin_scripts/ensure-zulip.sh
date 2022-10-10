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

check_zulip_installed() {
  # If zulip is not available on the path, get it
  if ! [ -x "$(command -v zulip)" ]; then
    echo 'zulip not found, installing'
    install_zulip
  fi
}


verify_zulip_version() {

  local zulip_version
  zulip_version="$(dnf list installed zulip | awk '{print $2}' | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"
  if [[ "${MINIMUM_ZULIP_VERSION}" != $(echo -e "${MINIMUM_ZULIP_VERSION}\n${zulip_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected zulip version: ${zulip_version}.
Requires ${MINIMUM_ZULIP_VERSION} or greater.
Please install ${MINIMUM_ZULIP_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing ZULIP' && install_zulip
  else
    cat <<EOF
Detected zulip version: ${zulip_version}.
Requires ${MINIMUM_ZULIP_VERSION} or greater.
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

install_zulip() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -L https://github.com/batistein/zulip-desktop/releases/download/v${MINIMUM_ZULIP_VERSION}/Zulip-${MINIMUM_ZULIP_VERSION}-x86_64.rpm -o zulip.rpm
      install_dnf
    else
      set +x
      echo "The installer does not work for your platform: $OSTYPE"
      exit 1
    fi

}

function install_dnf() {
  sudo dnf install -y zulip.rpm
  sudo rm -rf zulip.rpm
  echo "Installation Finished"
}

check_zulip_installed "$@"
verify_zulip_version "$@"