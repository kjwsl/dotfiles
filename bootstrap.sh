#!/bin/bash

FILES=(
    .aliasrc
    .bash_profile
    .bashrc
    .clang-format
    .config/fish
    .config/fontconfig
    .config/ghostty
    .config/kitty
    .config/nix
    .config/nvim
    .config/omf
    .config/sops
    .config/tmux
    .config/wezterm
    .config/wslu
    .config/zsh
    .envrc
    .fonts
    .gitconfig
    .oh-my-bash
    .p10k.zsh
    .profile
    .vim
    .zshenv
    .zshrc
    binaries
    modules
    obsidian-vault
    programs
)

if [[ ! -d "$HOME/.config" ]]; then
    mkdir -p "$HOME/.config"
fi

for file in ${FILES[@]}; do
    if [ -e $HOME/$file ]; then
        echo "File $file already exists in $HOME. Skipping..."
        continue
    fi
    ln -s $PWD/$file $HOME/$file
done
