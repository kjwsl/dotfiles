# Dotfiles Setup

This repository contains my personal dotfiles and system configuration. The setup is managed using Ansible for cross-platform compatibility.

## Quick Start

Run this one-liner to set up everything:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kjwsl/dotfiles/master/install.sh)"
```

## Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/kjwsl/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Run the installation script:
```bash
./install.sh
```

## What Gets Installed

The setup script will:

1. Install necessary prerequisites:
   - Python and pip
   - Ansible
   - Required Ansible collections

2. Configure your system with:
   - Shell configurations (zsh, fish)
   - Development tools
   - Terminal emulators
   - Fonts and themes
   - And more...

## Supported Platforms

- macOS (Darwin)
- Windows (via PowerShell)
- Linux:
  - Debian/Ubuntu
  - RedHat/Fedora
  - Arch Linux

## Features

- Cross-platform support
- Idempotent installation (safe to run multiple times)
- Automatic dependency management
- Verification of installation success

## Manual Configuration

If you prefer to set up manually:

1. Install Python and Ansible:
```bash
# macOS
brew install python ansible

# Debian/Ubuntu
sudo apt update
sudo apt install python3 python3-pip ansible

# RedHat/Fedora
sudo dnf install python3 python3-pip ansible

# Arch Linux
sudo pacman -S python python-pip ansible
```

2. Install required Ansible collections:
```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

3. Run the Ansible playbook:
```bash
ansible-playbook -i ansible/inventory.yml ansible/playbook.yml
```

## Troubleshooting

If you encounter any issues:

1. Check the installation logs
2. Verify Python and Ansible are installed correctly
3. Ensure you have the necessary permissions
4. Check the Ansible playbook for any platform-specific requirements

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details.
