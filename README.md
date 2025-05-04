# Larp's Dotfiles

Welcome to my dotfiles repository! This repository contains my personal configuration files and setup scripts for various tools and environments.

## 🚀 Quick Start

### Prerequisites

- Git
- Shell (Preferably Fish shell)
- Basic Unix tools (curl, wget, etc.)

### Installation

1. Clone the repository:
   ```bash
   git clone --recursive https://github.com/kjwsl/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the bootstrap script:
   ```bash
   ./bootstrap.sh
   ```

## 📦 Contents

### Shell Configurations
- `.bashrc` - Bash configuration with custom aliases and functions
- `.zshrc` - Zsh configuration with powerlevel10k theme
- `.profile` - Common shell environment settings
- `.aliasrc` - Custom shell aliases
- `.envrc` - Environment variables

### Development Tools
- `.gitconfig` - Git configuration with custom aliases and settings
- `.clang-format` - C/C++ code formatting rules
- `.vim/` - Vim configuration and plugins

### System Configurations
- `.config/` - Application-specific configurations
- `windows/` - Windows-specific settings and scripts
- `.fonts/` - Custom fonts and icon sets

### Utilities
- `binaries/` - Custom compiled binaries
- `scripts/` - Utility scripts for various tasks
- `modules/` - Modular configuration components

## 🔧 Features

### Shell Environment
- Powerlevel10k theme with custom prompt
- Custom aliases for common commands
- Environment variable management
- Path management and cleanup

### Development Environment
- Git configuration with custom aliases
- Vim setup with plugins and custom mappings
- Code formatting rules for various languages
- Development tool configurations

### System Integration
- WSL compatibility settings
- Windows-specific configurations
- Font and theme management
- Application-specific settings

## 📁 Directory Structure

```
.
├── .config/          # Application configurations
├── binaries/         # Custom binary files
├── scripts/          # Utility scripts
├── windows/          # Windows-specific configurations
├── modules/          # Modular configuration components
├── .fonts/           # Custom fonts
└── .vst3/            # VST3 plugin configurations
```

## 🛠️ Customization

Feel free to customize these configurations to suit your needs. The modular structure allows for easy modification of individual components without affecting the entire setup.

## 🤝 Contributing

While this is primarily a personal repository, suggestions and improvements are welcome. Please feel free to open issues or submit pull requests.

## 📄 License

This repository is licensed under the MIT License. See the LICENSE file for details.

## 📝 Notes

- For Windows users, ensure WSL is properly configured before installation
- Some configurations may require additional dependencies
- Custom scripts may need to be adjusted based on your system setup