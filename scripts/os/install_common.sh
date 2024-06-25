#!/bin/bash

set -e

cd "$(dirname "$0")"
source ../common.sh

# if ! is-executable lazydocker; then
#   info 'lazydocker installing'
#   curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
# fi

success 'all done'
