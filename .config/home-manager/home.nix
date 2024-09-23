{ config, pkgs, lib, inputs, configDir, ... }:

let
  homeDir =
    if pkgs.stdenv.isLinux
    then lib.mkDefault "/home/ray"
    else lib.mkDefault "/Users/ray";
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # It's also possible to use a ssh key, but only when it has no password:
    #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
    defaultSopsFile = ../sops/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${homeDir.content}/.config/sops/age/keys.txt"; # must have no password!

    secrets = {
      "omnivore_api_key" = {
        path = "${homeDir.content}/tmp/secrets.yaml";
      };
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  # systemd.user.services."myservice" = {
  #   script = ''
  #     #!/bin/sh
  #     echo "omnivore_api_key: ${config.sops.secrets.omnivore_api_key.key}"
  #   '';
  #   serviceConfig = {
  #     User = config.home.username;
  #     WorkingDirectory = "/var/lib/myservice";
  #   };
  # };

  home.username = lib.mkDefault "ray";
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  programs = {
    bash = {
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
    fish = {
      shellAliases = {
        g = "git";
        ls = "ls -ah --color";
        ll = "ls -lah --color";

      };
    };
    zsh = {
      enable = true;
      initExtra = ''
        if [[ -f ~/.p10k.zsh ]]; then
            source ~/.p10k.zsh
        fi
      '';
      enableCompletion = true;
      autosuggestion.enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        v = "nvim";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
          { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
          { name = "zsh-users/zsh-syntax-highlighting"; } # Installations with additional options. For the list of options, please refer to Zplug README.
          { name = "catppuccin/zsh-syntax-highlighting"; }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-completions"; }
          { name = "zsh-users/zsh-history-substring-search"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
      };
    };
  };

  programs = {
    git = {
      enable = true;
      userEmail = "kjwdev01@gmail.com";
      userName = "kjwsl";
      aliases = {
        i = "init";
        aa = "add .";
        co = "commit";
        ca = "commit -a";
        cm = "commit -am";
        ps = "push";
        pu = "pull";
        stu = "status HEAD";
        sts = "stash";
        sw = "switch";
        di = "diff";
      };
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        prompt = "enabled";
      };
      gitCredentialHelper.hosts = [
        "https://github.com"
        "https://gist.github.com"
      ];
    };

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };

    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        catppuccin
        jump
        yank
        tmux-fzf
        sensible
        resurrect
        continuum
        mode-indicator
        vim-tmux-navigator
      ];
      mouse = true;
      prefix = "C-s";
      clock24 = true;
      keyMode = "vi";
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };



    lazygit.enable = true;

    neovim = {
      enable = true;
      # plugins = with pkgs; [
      #         vimPlugins.nvim-treesitter
      #     	    vimPlugins.nvim-treesitter.withAllGrammars
      #     	    vimPlugins.nvim-treesitter-context
      #     	    vimPlugins.nvim-treesitter-refactor
      #     	    vimPlugins.nvim-treesitter-endwise
      #     	    vimPlugins.completion-treesitter
      #     	    luajitPackages.luarocks-build-treesitter-parser
      # ];
    };
  };

  home.shellAliases = {
    v = "nvim";
    vim = "nvim";
    g = "git";
    ls = "ls -ah --color";
    ll = "ls -lah --color";
  };

  home.packages = with pkgs; [
    gnumake
    zoxide
    cmake
    libclang
    unzip
    stow
    ripgrep
    rustup
    fastfetch
    bat
    nixd
    ripgrep
    git-repo
    nodejs_22
    #fish
    # oh-my-fish
    # fishPlugins.fzf
    # fishPlugins.done
    # fishPlugins.bass
    # fishPlugins.git-abbr
    # fishPlugins.autopair
    # arc-browser
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config" = {
      recursive = true;
      source = ../config/.config;
    };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ray/etc/profile.d/hm-session-vars.sh
  #
  home.sessionPath = [


  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
