#!/usr/bin/bash

if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export LIBRARY_PATH="/opt/homebrew/opt/libiconv/lib:$LIBRARY_PATH"
    export CPATH="/opt/homebrew/opt/libiconv/include:$CPATH"
    export PKG_CONFIG_PATH="/opt/homebrew/opt/libiconv/lib/pkgconfig:$PKG_CONFIG_PATH"
    if [[ -d /opt/homebrew/opt/llvm/bin ]]; then
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
        # export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
        # export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
    fi

fi

