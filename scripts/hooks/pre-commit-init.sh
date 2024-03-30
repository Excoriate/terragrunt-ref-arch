#!/usr/bin/env bash
#
##################################################################################
# Script Name: Pre-Commit Hook Manager
#
# Author: Alex Torres (github.com/Excoriate), alex_torres@outlook.com
#
# Usage: ./script.sh --hook-type=[hook-type]
#
# Description: This bash script provides functionality to install pre-commit on the specified git hooks.
#              It's designed to be used as a simple CLI tool to manage the git hooks.
#
# Parameters:
#    --hook-type: The type of the git hook to manage. Supported values are "commit", "prepush" and "commitmsg".
#                 The default is "prepush".
#
# Examples:
#    Install pre-commit on commit hook:   ./script.sh --hook-type=commit
#    Install pre-commit on pre-push hook: ./script.sh --hook-type=prepush
#    Install pre-commit on commit-msg hook: ./script.sh --hook-type=commitmsg
#
# Note: The script assumes that pre-commit is installed in the system. If not, it tries to install it using pip.
#
# For further details and support, contact the author.
#
##################################################################################
set -euo pipefail
readonly DEFAULT_HOOK_TYPE="prepush"

# Log a message
log() {
    local -r msg="${1}"
    echo "${msg}"
}

ensure_pre_commit_is_installed(){
    if ! command -v pre-commit &> /dev/null
    then
        log "pre-commit is not installed. Please install it using pip or your package manager."
        exit 1
    else
        log "pre-commit is already installed."
    fi
}

install_pre_commit_on_commit_hook(){
    log "Installing pre-commit on commit hooks..."
    pre-commit install --hook-type pre-commit
}

install_pre_commit_on_pre_push_hook(){
    log "Installing pre-commit on pre-push hooks..."
    pre-commit install --hook-type pre-push
}

install_pre_commit_on_commit_msg_hook(){
    log "Installing pre-commit on commit-msg hooks..."
    pre-commit install --hook-type commit-msg
}

# Main entry point
main() {
    ensure_pre_commit_is_installed
    local hook_type="${DEFAULT_HOOK_TYPE}"
    while [ $# -gt 0 ]; do
        case "$1" in
        --hook-type=*)
            hook_type="${1#*=}"
            shift
            ;;
        *)
            printf "*************************************\n"
            printf "* Error: Invalid argument.         *\n"
            printf "* Expected: --hook-type=[hook-type]*\n"
            printf "*************************************\n"
            exit 1
        esac
    done

    # Print the arguments received
    log "Hook type: ${hook_type}"

    case "${hook_type}" in
        commit)
            install_pre_commit_on_commit_hook
          ;;
        prepush)
            install_pre_commit_on_pre_push_hook
          ;;
        commitmsg)
            install_pre_commit_on_commit_msg_hook
          ;;
        *)
          log "Error: Invalid hook type '${hook_type}'. Valid values are 'commit', 'prepush', 'commitmsg'."
          exit 1
    esac
}

main "$@"
