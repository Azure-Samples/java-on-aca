#!/usr/bin/env bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function random_element() {

    local array=("$@")
    local array_length=${#array[@]}

    if [[ $array_length -gt 0 ]]; then
        local index=$((RANDOM % array_length))
        echo ${array[index]}
    else
        echo ""
    fi
}
