#!/usr/bin/bash

if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ -d /opt/homebrew/opt/llvm/bin ]]; then
    export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    # export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
    # export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
fi
