# Larp's Dotfiles

Welcome to my dotfiles repository! This repository contains my personal configuration files and setup scripts, managed by [Dotter](https://github.com/SuperCuber/dotter).

## 🚀 Quick Start

### Prerequisites

- [Dotter](https://github.com/SuperCuber/dotter) (binary will be installed if using bootstrap, or install manually)
- Shell (Preferably Fish shell)
- Basic Unix tools (curl, wget, etc.)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kjwsl/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Deploy with Dotter:
   ```bash
   dotter deploy
   ```
   
   To see what will happen without making changes:
   ```bash
   dotter deploy --dry-run
   ```

## 📦 Features

- **Cross-Platform**: Configurations for macOS, Linux, and Windows.
- **Templating**: Uses Dotter for flexible templating and machine-specific config.
- **Secrets**: Integrated with Bitwarden (`bw` CLI) for secret management.

### Packages
- **default**: Standard config for all machines (`.zshrc`, `.config`, etc.)
- **powershell**: Windows PowerShell profile (enable on Windows machines)

To enable the PowerShell package:
```bash
dotter use powershell
```
Or edit `.dotter/local.toml`.

## 📁 Directory Structure
- `.dotter/` - Dotter configuration (global and local)
- `binaries/` - Custom binaries
- `scripts/` - Utility scripts

## 🤝 Contributing
Feel free to open issues or submit pull requests.

## 📄 License
MIT License.