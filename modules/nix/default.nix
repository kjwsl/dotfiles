{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable binary caches for faster installation
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://hyprland.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];

  # Enable garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Development tools
    git
    neovim
    tmux
    htop
    ripgrep
    fd
    fzf
    bat
    eza
    zoxide
    delta
    bottom
    dust
    procs

    # System tools
    wget
    curl
    unzip
    p7zip
    gnupg
    pass
    age
    sops

    # Modern replacements
    starship
    eza
    delta
    bottom
    dust
    procs
  ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -a";
      lla = "eza --icons -la";
      tree = "eza --icons --tree";
    };
  };

  # Starship configuration
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}