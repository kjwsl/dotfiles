#!/bin/bash

FILES=(
    .bashrc
    .bash_profile
    .aliasrc
    .envrc
    .gitconfig
    .p10k.zsh
    .zshrc
    .zshenv
    .fonts
    .clang-format
    .oh-my-bash
    obsidian-vault
    binaries
    programs
    modules
    .config/fish
    .config/nvim
    .config/wezterm
    .config/sops
    .config/tmux
    .config/zsh
    .config/wslu
    .config/omf
    .config/nix
    .config/kitty
    .config/alacritty
    .config/fontconfig
    .config/sops
)

for file in ${FILES[@]}; do
    if [ -e $HOME/$file ]; then
        echo "File $file already exists in $HOME. Skipping..."
        continue
    fi
    ln -s $PWD/$file $HOME/$file
done
