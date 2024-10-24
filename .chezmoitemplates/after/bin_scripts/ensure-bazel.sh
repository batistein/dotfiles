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

check_bazel_installed() {
  # If bazel is not available on the path, get it
  if ! [ -x "$(command -v bazel)" ]; then
    echo 'bazel not found, installing'
    install_bazel
  fi
}


verify_bazel_version() {

  local bazel_version
  bazel_version="$( bazel version | grep "Bazelisk version" | awk '{print $3}' | grep -Eo "([0-9]{1,}\.)+[0-9]{1,}")"
  if [[ "${MINIMUM_BAZEL_VERSION}" != $(echo -e "${MINIMUM_BAZEL_VERSION}\n${bazel_version}" | sort -s -t. -k 1,1n -k 2,2n -k 3,3n | head -n1) ]]; then
    cat <<EOF
Detected bazel version: ${bazel_version}.
Requires ${MINIMUM_BAZEL_VERSION} or greater.
Please install ${MINIMUM_BAZEL_VERSION} or later.

EOF
    
    confirm "$@" && echo 'Installing BAZEL' && install_bazel
  else
    cat <<EOF
Detected bazel version: ${bazel_version}.
Requires ${MINIMUM_BAZEL_VERSION} or greater.
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

install_bazel() {
    if [[ "${OSTYPE}" == "linux"* ]]; then
      curl -sLo "bazel" https://github.com/bazelbuild/bazelisk/releases/download/v${MINIMUM_BAZEL_VERSION}/bazelisk-linux-amd64
      copy_binary
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      curl -sLo "bazel" https://github.com/bazelbuild/bazelisk/releases/download/v${MINIMUM_BAZEL_VERSION}/bazelisk-darwin-amd64
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
      mv bazel "$HOME/.local/bin/bazel"
      chmod +x "$HOME/.local/bin/bazel"
  else
      echo "Installing BAZEL to /usr/local/bin which is write protected"
      echo "If you'd prefer to install BAZEL without sudo permissions, add \$HOME/.local/bin to your \$PATH and rerun the installer"
      sudo mv bazel /usr/local/bin/bazel
      chmod +x "/usr/local/bin/bazel"
  fi
  echo "Installation Finished"
}

check_bazel_installed "$@"
verify_bazel_version "$@"