#!/bin/bash

FILES=(
    .aliasrc
    .bash_profile
    .bashrc
    .clang-format
    .config/alacritty
    .config/fish
    .config/fontconfig
    .config/kitty
    .config/nix
    .config/nvim
    .config/omf
    .config/sops
    .config/sops
    .config/tmux
    .config/wezterm
    .config/wslu
    .config/zsh
    .envrc
    .fonts
    .gitconfig
    .p10k.zsh
    .profile
    .zshenv
    .zshrc
    binaries
    modules
    obsidian-vault
    programs
)

for file in ${FILES[@]}; do
    if [ -e $HOME/$file ]; then
        echo "File $file already exists in $HOME. Skipping..."
        continue
    fi
    ln -s $PWD/$file $HOME/$file
done
