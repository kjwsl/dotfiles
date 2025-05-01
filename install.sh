#!/usr/bin/env bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    case $level in
        "info") echo -e "${BLUE}[INFO]${NC} $*" ;;
        "success") echo -e "${GREEN}[SUCCESS]${NC} $*" ;;
        "warning") echo -e "${YELLOW}[WARNING]${NC} $*" ;;
        "error") echo -e "${RED}[ERROR]${NC} $*" >&2 ;;
    esac
}

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

# Function to get the dotfiles directory
get_dotfiles_dir() {
    local repo_url="https://github.com/kjwsl/dotfiles.git"
    local target_dir="$HOME/.dotfiles"
    
    # Check if we're in a git repository
    if [ -d ".git" ] && [ -f "flake.nix" ]; then
        echo "$(pwd)"
        return
    fi
    
    # Check if dotfiles directory exists
    if [ -d "$target_dir" ] && [ -f "$target_dir/flake.nix" ]; then
        echo "$target_dir"
        return
    fi
    
    # Clone the repository
    log "info" "Cloning repository..."
    git clone "$repo_url" "$target_dir"
    echo "$target_dir"
}

# Function to check if Nix is properly installed and configured
check_nix_installation() {
    local os=$(detect_os)
    
    # Check if nix command exists
    if ! command_exists nix; then
        log "info" "Nix is not installed"
        return 1
    fi
    
    # Check if nix-daemon is running (macOS specific)
    if [ "$os" = "darwin" ]; then
        if ! launchctl list | grep -q "org.nixos.nix-daemon"; then
            log "warning" "Nix daemon is not running"
            return 1
        fi
    fi
    
    # Check if flakes are enabled
    if ! nix flake --help >/dev/null 2>&1; then
        log "warning" "Nix flakes are not enabled"
        return 1
    fi
    
    # Check if nix.conf has the right settings
    if [ -f /etc/nix/nix.conf ]; then
        if ! grep -q "experimental-features = nix-command flakes" /etc/nix/nix.conf; then
            log "warning" "Nix configuration needs updating"
            return 1
        fi
    fi
    
    log "success" "Nix is properly installed and configured"
    return 0
}

# Function to install Nix with flakes support
install_nix() {
    local os=$(detect_os)
    
    # Check if Nix is already properly installed
    if check_nix_installation; then
        log "info" "Nix is already installed and configured"
        return 0
    fi
    
    log "info" "Installing Nix package manager with flakes support..."
    case "$os" in
        darwin)
            # Use the official Nix installer for macOS
            log "info" "Installing Nix using the official installer..."
            sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume
            # Source Nix environment
            if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
                . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
            fi
            ;;
        debian|ubuntu)
            sh <(curl -L https://nixos.org/nix/install) --daemon
            ;;
        redhat|fedora)
            sh <(curl -L https://nixos.org/nix/install) --daemon
            ;;
        arch)
            sudo pacman -S --noconfirm nix
            ;;
        *)
            log "error" "Could not install Nix. Please install it manually."
            exit 1
            ;;
    esac

    # Enable flakes
    if [ ! -f /etc/nix/nix.conf ] || ! grep -q "experimental-features" /etc/nix/nix.conf; then
        log "info" "Enabling flakes in Nix configuration..."
        echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
    fi

    # Create flake.lock
    if [ -f "flake.nix" ] && [ ! -f "flake.lock" ]; then
        log "info" "Creating flake.lock file..."
        nix flake lock
    fi
    
    # Verify installation
    if ! check_nix_installation; then
        log "error" "Nix installation failed verification"
        exit 1
    fi
}

# Function to set up Home Manager
setup_home_manager() {
    local os=$(detect_os)
    local username=$(whoami)
    
    if ! command_exists home-manager; then
        log "info" "Installing Home Manager..."
        nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
        nix-channel --update
        
        case "$os" in
            darwin)
                nix-shell '<home-manager>' -A install
                ;;
            *)
                nix-shell '<home-manager>' -A install
                ;;
        esac
    fi
    
    # Apply Home Manager configuration
    log "info" "Applying Home Manager configuration..."
    home-manager switch --flake .
}

# Function to verify installation
verify_installation() {
    log "info" "Verifying installation..."
    
    # Check Nix
    if ! command_exists nix; then
        log "error" "Nix installation failed"
        return 1
    fi
    
    # Check flake support
    if ! nix flake --help >/dev/null 2>&1; then
        log "error" "Nix flakes not enabled"
        return 1
    fi
    
    # Check flake.lock
    if [ ! -f "flake.lock" ]; then
        log "error" "flake.lock file not found"
        return 1
    fi
    
    # Check Home Manager
    if ! command_exists home-manager; then
        log "error" "Home Manager installation failed"
        return 1
    fi

    # Check Nix daemon (macOS specific)
    if [ "$(detect_os)" = "darwin" ]; then
        if ! launchctl list | grep -q "org.nixos.nix-daemon"; then
            log "error" "Nix daemon not running"
            return 1
        fi
    fi
    
    log "success" "Installation verified successfully"
    return 0
}

# Main installation process
main() {
    log "info" "Starting installation process..."
    
    # Get the dotfiles directory
    local dotfiles_dir=$(get_dotfiles_dir)
    log "info" "Using dotfiles directory: $dotfiles_dir"
    
    # Install Nix with flakes support
    install_nix
    
    # Set up Home Manager
    setup_home_manager
    
    # Verify installation
    if ! verify_installation; then
        log "error" "Installation verification failed. Please check the logs above."
        exit 1
    fi
    
    log "success" "Installation complete!"
    log "info" "Next steps:"
    log "info" "1. Run 'nix develop' to enter the development shell"
    log "info" "2. Run 'home-manager switch --flake .' to apply the configuration"
    log "info" "3. Restart your shell to apply the changes"
}

# Run the main function
main




