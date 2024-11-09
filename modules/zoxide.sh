#!/bin/bash

if  command -v zoxide > /dev/null; then
    if [[ $SHELL == *bash* || $SHELL == *zsh* ]]; then
        # Zinit uses this alias
        unalias zi &> /dev/null
        cur_shell=$(basename $SHELL)
        eval "$(zoxide init $cur_shell)"
    fi
fi
