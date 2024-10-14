#!/bin/bash

if  command -v zoxide > /dev/null; then
    if [[ $SHELL == *bash* || $SHELL == *zsh* ]]; then
        # Zinit uses this alias
        unalias zi
        cur_shell=$(basename $SHELL)
        eval "$(zoxide init $cur_shell)"
    elif [[ $SHELL == *fish* ]]; then
        zoxide init fish | source
    fi

fi
