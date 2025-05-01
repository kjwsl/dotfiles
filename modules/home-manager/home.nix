{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is compatible with
  home.stateVersion = "23.11";

  # Modern command-line tools
  home.packages = with pkgs; [
    # Modern replacements
    eza
    zoxide
    fzf
    ripgrep
    fd
    bat
    delta
    bottom
    dust
    procs

    # Development tools
    git
    neovim
    tmux
    htop

    # System tools
    wget
    curl
    unzip
    p7zip
    gnupg
    pass
    age
    sops
  ];

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza --icons -l";
      la = "eza --icons -a";
      lla = "eza --icons -la";
      tree = "eza --icons --tree";
    };
  };

  # Starship prompt
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

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    clock24 = true;
    newSession = true;
    terminal = "screen-256color";
    extraConfig = ''
      set -g mouse on
      set -g status-keys vi
      set -g mode-keys vi
    '';
  };
}