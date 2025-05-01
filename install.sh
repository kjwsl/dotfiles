#!/usr/bin/env bash

set -e

# Function to detect the operating system
detect_os() {
    case "$(uname -s)" in
        Linux*)
            if [ -f /etc/debian_version ]; then
                echo "debian"
            elif [ -f /etc/redhat-release ]; then
                echo "redhat"
            elif [ -f /etc/arch-release ]; then
                echo "arch"
            else
                echo "linux"
            fi
            ;;
        Darwin*)
            echo "darwin"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get the script directory
get_script_dir() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    echo "$DIR"
}

# Function to clone the repository if needed
setup_repository() {
    local repo_url="https://github.com/kjwsl/dotfiles.git"
    local target_dir="$HOME/.dotfiles"
    
    if [ ! -d "$target_dir" ]; then
        echo "Cloning repository..."
        git clone "$repo_url" "$target_dir"
    fi
    
    echo "$target_dir"
}

# Function to verify installation
verify_installation() {
    echo "Verifying installation..."
    
    # Check Python
    if ! command_exists python3; then
        echo "❌ Python installation failed"
        return 1
    fi
    
    # Check Ansible
    if ! command_exists ansible; then
        echo "❌ Ansible installation failed"
        return 1
    fi
    
    # Check Ansible collections
    if [ ! -f "$HOME/.ansible/collections/ansible_collections/community/general/__init__.py" ]; then
        echo "❌ Ansible collections installation failed"
        return 1
    fi
    
    echo "✅ Installation verified successfully"
    return 0
}

# Function to install Python and pip if not present
install_python() {
    local os=$(detect_os)
    
    if ! command_exists python3; then
        echo "Installing Python..."
        case "$os" in
            darwin)
                if command_exists brew; then
                    brew install python
                else
                    echo "Please install Homebrew first: https://brew.sh/"
                    exit 1
                fi
                ;;
            debian)
                sudo apt-get update
                sudo apt-get install -y python3 python3-pip
                ;;
            redhat)
                sudo dnf install -y python3 python3-pip
                ;;
            arch)
                sudo pacman -S --noconfirm python python-pip
                ;;
            windows)
                if command_exists choco; then
                    choco install python -y
                else
                    echo "Please install Chocolatey first: https://chocolatey.org/install"
                    exit 1
                fi
                ;;
            *)
                echo "Could not install Python. Please install it manually."
                exit 1
                ;;
        esac
    fi
}

# Function to install Ansible
install_ansible() {
    local os=$(detect_os)
    
    if ! command_exists ansible; then
        echo "Installing Ansible..."
        case "$os" in
            darwin|debian|redhat|arch)
                pip3 install --user ansible
                ;;
            windows)
                if command_exists choco; then
                    choco install ansible -y
                else
                    pip3 install --user ansible
                fi
                ;;
        esac
    fi
}

# Function to install required Ansible collections
install_ansible_collections() {
    local dotfiles_dir="$1"
    echo "Installing required Ansible collections..."
    ansible-galaxy collection install -r "$dotfiles_dir/ansible/requirements.yml"
}

# Function to run the Ansible playbook
run_ansible_playbook() {
    local dotfiles_dir="$1"
    echo "Running Ansible playbook..."
    ansible-playbook -i "$dotfiles_dir/ansible/inventory.yml" "$dotfiles_dir/ansible/playbook.yml"
}

# Function to install platform-specific prerequisites
install_prerequisites() {
    local os=$(detect_os)
    
    case "$os" in
        debian)
            sudo apt-get update
            sudo apt-get install -y software-properties-common
            ;;
        redhat)
            sudo dnf install -y epel-release
            ;;
        arch)
            sudo pacman -S --noconfirm base-devel
            ;;
        windows)
            if ! command_exists choco; then
                echo "Installing Chocolatey..."
                powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
            fi
            ;;
    esac
}

# Main installation process
main() {
    echo "Starting installation process..."
    
    # Setup repository
    local dotfiles_dir=$(setup_repository)
    
    # Install platform-specific prerequisites
    install_prerequisites
    
    # Install Python and pip if needed
    install_python
    
    # Install Ansible
    install_ansible
    
    # Install required Ansible collections
    install_ansible_collections "$dotfiles_dir"
    
    # Run the Ansible playbook
    run_ansible_playbook "$dotfiles_dir"
    
    # Verify installation
    if ! verify_installation; then
        echo "Installation verification failed. Please check the logs above."
        exit 1
    fi
    
    echo "Installation complete!"
}

# Run the main function
main




