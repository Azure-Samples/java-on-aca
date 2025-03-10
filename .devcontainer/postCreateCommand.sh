#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CHECK_AZD=$(which azd)
if [[ ! -z "$CHECK_AZD" ]]; then
    azd config set alpha.deployment.stacks on
fi

grep JAVA_AI_FUNC "$HOME/.bashrc" > /dev/null 2>&1
if [[ $? -ne 0 ]]; then

    cat <<EOT >> "$HOME/.bashrc"
JAVA_AI_FUNC="$DIR"
[ -f "\$JAVA_AI_FUNC/funcs.sh" ] && \. "\$JAVA_AI_FUNC/funcs.sh"

loadenv

EOT

fi
