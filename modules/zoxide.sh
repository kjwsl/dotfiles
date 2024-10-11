#!/bin/bash

if  command -v zoxide > /dev/null; then
    if [[ $SHELL == *bash* || $SHELL == *zsh* ]]; then
        eval "$(zoxide init zsh)"
    elif [[ $SHELL == *fish* ]]; then
        zoxide init fish | source
    fi

fi
