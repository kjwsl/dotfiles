#!/usr/bin/env bash

source scripts/tools.sh

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
    .config/git/config
    .config/gtk-3.0
    .config/gtk-4.0
    .config/hypr
    .config/kitty
    .config/nix
    .config/nvim
    .config/omf
    .config/sops
    .config/tmux
    .config/wezterm
    .config/zsh
    .envrc
    .fonts
    .oh-my-bash
    .p10k.zsh
    .profile
    .vim
    .zshenv
    .zshrc
    binaries
    modules
)

DECRYPT_FILES=(
)

# Create the timestamp-based backup directory
mkdir -p "$BACKUP_DIR_WITH_TS"

backup_and_link() {
    local source_path="$HOME/$1"
    local backup_path="$BACKUP_DIR_WITH_TS/$1"
    local backup_dir=$(dirname "$backup_path")

    # Only backup if the file/directory exists and is not a symlink pointing to our dotfiles
    if [ -e "$source_path" ] && [ ! -L "$source_path" -o "$(readlink "$source_path")" != "$PWD/$1" ]; then
        info "Backing up $source_path to $backup_path..."
        mkdir -p "$backup_dir"
        mv "$source_path" "$backup_dir/" 2>/dev/null || warn "Warning: Could not move $source_path to backup."
    elif [ -L "$source_path" ] && [ "$(readlink "$source_path")" = "$PWD/$1" ]; then
        warn "Already linked correctly: $source_path."
        return 0
    fi

    # Create the parent directory if it doesn't exist
    mkdir -p "$(dirname "$source_path")"

    # Create the symbolic link
    echo "Creating symlink for $1"
    ln -sf "$PWD/$1" "$source_path" || echo "Warning: Could not create symlink for $1."
}

decrypt() {
    FILE="$1"
    if [ -f "$FILE" ]; then
        info "Decrypting $FILE..."
        sops -d "$FILE" > "${FILE/.enc/}" || {
            error "Failed to decrypt $FILE."
            return 1
        }
    else
        error "File $FILE does not exist."
        return 1
    fi
}

main() {
    if [[ ! -d "$HOME/.config" ]]; then
        info "$HOME/.config does not exist. Creating it..."
        mkdir -p "$HOME/.config"
    fi

    info "Backing up and linking files..."
    failures=0
    for file in "${FILES[@]}"; do
        if [[ "$file" == "modules" || "$file" == "binaries" ]]; then
            # Skip these directories for now
            continue
        fi

        if [[ "$file" == *".enc"* ]]; then
            # Skip encrypted files for now
            continue
        fi

        backup_and_link "$file" || {
            error "Failed to backup and link $file."
            failures=$((failures + 1))
            continue
        }
    done
    if [ $failures -gt 0 ]; then
        warn "There were $failures failures during the backup and link process."
    else
        success "All files backed up and linked successfully."
    fi

    for file in "${DECRYPT_FILES[@]}"; do
        decrypt "$file" || {
            if [ ! -f ~/.config/sops/age/keys.txt ]; then
                error "Please install age and create ~/.config/sops/age/keys.txt."
                exit 1
            else
                error "Failed to decrypt $file."
            fi
        }
    done
}

main "$@"
