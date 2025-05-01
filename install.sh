#!/usr/bin/env bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Debug function
log_debug() {
    if [ -n "$DEBUG" ]; then
        echo -e "${YELLOW}[DEBUG]${NC} $1"
    fi
}

# Check if running on macOS
is_macos() {
    [[ "$(uname)" == "Darwin" ]]
}

# Check if a command exists
command_exists() {
    local cmd="$1"
    log_debug "Checking if command exists: $cmd"
    if command -v "$cmd" >/dev/null 2>&1; then
        log_debug "Command found: $(which "$cmd")"
        return 0
    else
        log_debug "Command not found: $cmd"
        return 1
    fi
}

# Check if a file exists
file_exists() {
    [[ -f "$1" ]]
}

# Check if a directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Ensure PATH includes Homebrew binaries
ensure_brew_path() {
    log_debug "Current PATH: $PATH"
    if is_macos; then
        if [[ -x "/opt/homebrew/bin/brew" ]]; then
            log_debug "Found Homebrew at /opt/homebrew/bin/brew"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x "/usr/local/bin/brew" ]]; then
            log_debug "Found Homebrew at /usr/local/bin/brew"
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        log_debug "Updated PATH: $PATH"
    fi
}

# Install Homebrew on macOS
install_homebrew() {
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH if not already there
        if is_macos; then
            if [[ -x "/opt/homebrew/bin/brew" ]]; then
                if ! grep -q "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" ~/.zprofile 2>/dev/null; then
                    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                fi
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -x "/usr/local/bin/brew" ]]; then
                if ! grep -q "eval \"\$(/usr/local/bin/brew shellenv)\"" ~/.zprofile 2>/dev/null; then
                    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
                fi
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
    else
        log_info "Homebrew already installed"
        log_info "Updating Homebrew..."
        ensure_brew_path
        brew update
    fi
}

# Install Fish shell
install_fish() {
    # First, ensure Homebrew PATH is set
    ensure_brew_path

    # Check common Fish locations
    local fish_locations=(
        "/opt/homebrew/bin/fish"
        "/usr/local/bin/fish"
        "/usr/bin/fish"
        "$(which fish 2>/dev/null)"
    )

    # Check if fish is actually available and working
    local fish_found=false
    local fish_path=""
    for location in "${fish_locations[@]}"; do
        log_debug "Checking Fish location: $location"
        if [[ -x "$location" ]] && "$location" --version >/dev/null 2>&1; then
            fish_found=true
            fish_path="$location"
            log_info "Found working Fish shell at: $location"
            break
        fi
    done

    if ! $fish_found; then
        log_info "Fish shell not found or not working, installing..."
        if is_macos; then
            # Try to uninstall any broken Fish installation
            brew uninstall fish || true
            # Install Fish
            brew install fish
            # Verify installation
            if ! brew list fish >/dev/null 2>&1; then
                log_error "Failed to install Fish via Homebrew"
                log_error "Please check Homebrew installation and try again"
                exit 1
            fi
        else
            sudo apt-get update
            sudo apt-get install -y fish
        fi
    else
        log_info "Fish shell already installed at $fish_path"
        if is_macos; then
            brew upgrade fish
        fi
    fi

    # Ensure fish is in /etc/shells
    if is_macos; then
        if ! grep -q "$fish_path" /etc/shells; then
            log_info "Adding Fish to /etc/shells..."
            echo "$fish_path" | sudo tee -a /etc/shells
        fi
    fi

    # Export fish_path for use in other functions
    export FISH_PATH="$fish_path"
    log_debug "Exported FISH_PATH: $FISH_PATH"
}

# Install Ansible
install_ansible() {
    if ! command_exists ansible; then
        log_info "Installing Ansible..."
        if is_macos; then
            ensure_brew_path
            brew install ansible
        else
            sudo apt-get update
            sudo apt-get install -y ansible
        fi
    else
        log_info "Ansible already installed"
        if is_macos; then
            ensure_brew_path
            brew upgrade ansible
        fi
    fi
}

# Install Fisher and plugins
setup_fish() {
    log_info "Setting up Fish shell..."
    log_debug "Using FISH_PATH: $FISH_PATH"
    
    # Create Fish config directory if it doesn't exist
    if [ ! -d "$HOME/.config/fish" ]; then
        mkdir -p "$HOME/.config/fish"
    fi
    
    # Install Fisher
    if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
        log_info "Installing Fisher..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    else
        log_info "Fisher already installed"
    fi

    # Install plugins
    log_info "Installing/updating Fish plugins..."
    for plugin in "${shell_config[fish_plugins][@]}"; do
        if ! "$FISH_PATH" -c "fisher list" 2>/dev/null | grep -q "$plugin"; then
            log_info "Installing plugin: $plugin"
            "$FISH_PATH" -c "fisher install $plugin"
        else
            log_info "Plugin already installed: $plugin"
        fi
    done

    # Set Fish as default shell
    if [ "$SHELL" != "$FISH_PATH" ]; then
        log_info "Setting Fish as default shell..."
        if is_macos; then
            echo "$FISH_PATH" | sudo tee -a /etc/shells
            chsh -s "$FISH_PATH"
        else
            echo "$FISH_PATH" | sudo tee -a /etc/shells
            chsh -s "$FISH_PATH"
        fi
    else
        log_info "Fish is already the default shell"
    fi
}

# Run Ansible playbook
run_ansible() {
    log_info "Running Ansible playbook..."
    if [ -d "ansible" ]; then
        cd ansible
        ansible-playbook playbooks/dotfiles.yml
        cd ..
    else
        log_warn "Ansible directory not found. Skipping Ansible setup."
    fi
}

# Main installation process
main() {
    log_info "Starting installation process..."

    if is_macos; then
        install_homebrew
    fi

    install_fish
    install_ansible
    setup_fish
    run_ansible

    log_info "Installation completed successfully!"
    log_info "Please restart your shell to apply all changes"
}

# Run the main function
main "$@"




