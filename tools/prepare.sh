#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

bash $DIR/../.devcontainer/postCreateCommand.sh

bash $DIR/prepare-subscription.sh

bash $DIR/prepare-extensions.sh

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}INFO:${NC} Please quite this terminal and reopen it to have a full functional lab environment"