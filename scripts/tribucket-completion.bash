#!/usr/bin/env bash
# tribucket bash completion
# Source this file: sourcetribucket-completion.bash
# Or install to /etc/bash_completion.d/tribucket

_tribucket_completions() {
    local commands="install uninstall track untrack list check update info self-update config"
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Complete commands
    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=($(compgen -W "$commands" -- "$cur"))
        return
    fi

    # Complete subcommand arguments
    case "${COMP_WORDS[1]}" in
        update|check|uninstall|info)
            if [ "$COMP_CWORD" -eq 2 ]; then
                # Complete with tracked package names
                local packages
                packages=$(tribucket list --json 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(' '.join(data.get('packages', {}).keys()))
except:
    pass
" 2>/dev/null)
                COMPREPLY=($(compgen -W "$packages --all --help" -- "$cur"))
            fi
            ;;
        track)
            if [ "$COMP_CWORD" -eq 2 ]; then
                COMPREPLY=($(compgen -o default -- "$cur"))
            fi
            ;;
        config)
            if [ "$COMP_CWORD" -eq 2 ]; then
                COMPREPLY=($(compgen -W "list get set unset" -- "$cur"))
            elif [ "$COMP_CWORD" -eq 3 ] && [ "$prev" = "get" ]; then
                COMPREPLY=($(compgen -W "default_install_dir auto_link" -- "$cur"))
            elif [ "$COMP_CWORD" -eq 3 ] && [ "$prev" = "set" ]; then
                COMPREPLY=($(compgen -W "default_install_dir auto_link" -- "$cur"))
            elif [ "$COMP_CWORD" -eq 3 ] && [ "$prev" = "unset" ]; then
                COMPREPLY=($(compgen -W "default_install_dir auto_link" -- "$cur"))
            fi
            ;;
        install)
            if [ "$COMP_CWORD" -eq 2 ]; then
                COMPREPLY=($(compgen -W "--dir --link --force --mirror --help" -- "$cur"))
            fi
            ;;
    esac
}

complete -F _tribucket_completions tribucket
