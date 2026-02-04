#!/usr/bin/env bash
# ===========================================================================
# Installation script to place screenpipe script in PATH
# ===========================================================================

set -e

echo "[install-screenpipe] Installing screenpipe script to ~/.local/bin/"

# Create ~/.local/bin if it doesn't exist
mkdir -p ~/.local/bin

# The chezmoi template processor will place the script as an executable
# We just need to ensure the directory exists

echo "[install-screenpipe] Installation complete!"
echo "[install-screenpipe] Script location: ~/.local/bin/start-screenpipe.sh"
echo ""
echo "You can now:"
echo "  - Run manually: ~/.local/bin/start-screenpipe.sh"
echo "  - Add to PATH: export PATH=\$HOME/.local/bin:\$PATH"
echo "  - Auto-start on Windows: Next, run the startup setup script"
