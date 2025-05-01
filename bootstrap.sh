#!/usr/bin/env bash

BACKUP_DIR="$HOME/.dotfiles-backup"
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUP_DIR_WITH_TS="$BACKUP_DIR/$TIMESTAMP"

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

# Create the timestamp-based backup directory
mkdir -p "$BACKUP_DIR_WITH_TS"

backup_and_link() {
    local source_path="$HOME/$1"
    local backup_path="$BACKUP_DIR_WITH_TS/$1"
    local backup_dir=$(dirname "$backup_path")
    
    # Only backup if the file/directory exists and is not a symlink pointing to our dotfiles
    if [ -e "$source_path" ] && [ ! -L "$source_path" -o "$(readlink "$source_path")" != "$PWD/$1" ]; then
        echo "Backing up $source_path to $backup_path"
        mkdir -p "$backup_dir"
        mv "$source_path" "$backup_dir/" 2>/dev/null || echo "Warning: Could not move $source_path to backup"
    elif [ -L "$source_path" ] && [ "$(readlink "$source_path")" = "$PWD/$1" ]; then
        echo "Already linked correctly: $source_path"
        return
    fi

    # Create the parent directory if it doesn't exist
    mkdir -p "$(dirname "$source_path")"
    
    # Create the symbolic link
    echo "Creating symlink for $1"
    ln -sf "$PWD/$1" "$source_path"
}

if [[ ! -d "$HOME/.config" ]]; then
    mkdir -p "$HOME/.config"
fi

for file in "${FILES[@]}"; do
    backup_and_link "$file"
done

echo "Dotfiles setup complete! Backup created at $BACKUP_DIR_WITH_TS"
