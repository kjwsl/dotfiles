#!/usr/bin/bash

if command -v eza > /dev/null; then
    alias ls='eza -a --color=auto --icons=auto'
    alias ll='eza -lah --color=auto --icons=auto'
else
    alias ls='ls -ah --color=auto'
    alias ll='ls -lah --color=auto'
fi
