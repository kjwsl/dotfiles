{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # This value determines the Home Manager release that your configuration is compatible with
  home.stateVersion = "23.11";

  # Packages to install
  home.packages = with pkgs; [
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

    # Language tools
    python3
    nodejs
    go
    rustc
    cargo
    gcc
    clang
    cmake
    pkg-config

    # Language-specific tools
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.pip-tools
    python3Packages.black
    python3Packages.flake8
    python3Packages.mypy
    python3Packages.pytest
    yarn
    typescript
    eslint
    prettier
    go-tools
    rust-analyzer
    cargo-edit
    cargo-watch
    cargo-audit
    cargo-outdated

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

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
    GOPATH = "$HOME/.go";
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME = "$HOME/.cargo";
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
    };
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza -T";
      cat = "bat";
      grep = "rg";
      find = "fd";
      cd = "z";
      vim = "nvim";
      vi = "nvim";
    };
    initExtra = ''
      # Initialize zoxide
      eval "$(zoxide init zsh)"
      
      # Initialize fzf
      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
      
      # Add Go to PATH
      export PATH="$GOPATH/bin:$PATH"
      
      # Add Rust to PATH
      export PATH="$CARGO_HOME/bin:$PATH"
    '';
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
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      color.ui = true;
      core.editor = "nvim";
    };
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    prefix = "C-a";
    terminal = "screen-256color";
    extraConfig = ''
      # Enable true color
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      
      # Set window title
      set-option -g set-titles on
      set-option -g set-titles-string "#T"
      
      # Status bar
      set-option -g status-style bg=default,fg=white
      set-option -g status-left "#[fg=green]#S #[fg=white]|"
      set-option -g status-right "#[fg=white]| #[fg=green]#(whoami)@#H #[fg=white]| #[fg=green]%Y-%m-%d %H:%M"
      
      # Pane border
      set-option -g pane-border-style fg=white
      set-option -g pane-active-border-style fg=green
      
      # Window list
      set-option -g window-status-format "#[fg=white]#I:#W"
      set-option -g window-status-current-format "#[fg=green]#I:#W"
      
      # Copy mode
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection
      bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
    '';
  };
}