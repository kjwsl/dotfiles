#!/usr/bin/bash

if command -v eza > /dev/null; then
    alias ls='eza -l --color=auto --icons=auto'
    alias ll='eza -lah --color=auto --icons=auto'
fi
