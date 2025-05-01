# Larp's Dotfiles

Hey! Welcome to my dotfiles repo!

I manage my dotfiles using [chezmoi](https://www.chezmoi.io/), a powerful dotfile manager that supports multiple machines and operating systems.

## Structure

- `dot_config/` - Contains various application configurations
  - Terminal emulators (alacritty, kitty, wezterm)
  - Shell configurations (fish, zsh)
  - Window managers (hypr)
  - And many more application configs
- `dot_vim/` - Vim configuration
- `windows/` - Windows-specific configurations
- `modules/` - Additional modules and scripts
- `binaries/` - Custom binary files

## Key Configuration Files

- Shell configurations:
  - `dot_zshrc` - Zsh configuration
  - `dot_bashrc` - Bash configuration
  - `dot_profile` - Shell profile
  - `dot_aliasrc` - Shell aliases
- `dot_gitconfig` - Git configuration
- `dot_p10k.zsh` - Powerlevel10k theme configuration
- `dot_clang-format` - Clang format configuration

## Installation

1. Install chezmoi:
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)"
   ```

2. Apply the dotfiles:
   ```bash
   chezmoi init --apply https://github.com/yourusername/dotfiles.git
   ```

## Features

- Cross-platform support (Linux, macOS, Windows)
- Modular configuration structure
- Support for multiple terminal emulators
- Comprehensive shell configurations
- Various application-specific configurations
