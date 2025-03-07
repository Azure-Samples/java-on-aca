#!/usr/bin/env bash

DEV_ENV_FILE="$HOME/.dev-environment"

alias saveenv='declare -p | grep "declare \(--\|-x\)" | grep -v "^declare \(--\|-x\) \(PS[0-9]\|_.*\|SDKMAN_.*\|sdkman_.*\|IFS\|VSCODE_.*\|HIST.*\|GITHUB_.*\|BASH_.*\|COMP_WORDBREAKS\|PATH\|OLDPWD\|PWD\|LS_COLORS\)=" > "$DEV_ENV_FILE"'

alias loadenv='[ -f $DEV_ENV_FILE ] && source "$DEV_ENV_FILE"'

alias clearenv='rm -f "$DEV_ENV_FILE"'
