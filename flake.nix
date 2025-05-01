{
  description = "A Nix-based development environment configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin }: 
  let
    system = "aarch64-darwin";
    username = "ray"; # Hardcoded username instead of environment variable
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Simple Home Manager Configuration
    homeConfigurations."ray" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit username; };
      modules = [ ./modules/home-manager/home.nix ];
    };

    # Darwin Configuration
    darwinConfigurations."ray" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./modules/nix/default.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ray = {
            imports = [ ./modules/home-manager/home.nix ];
            home.stateVersion = "23.11";
          };
        }
      ];
    };

    # Development shell
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        # Development tools
        git neovim tmux htop ripgrep fd fzf bat eza zoxide delta bottom dust procs
        # Language tools
        python3 nodejs go rustc cargo gcc clang cmake pkg-config
        # Language-specific tools
        python3Packages.pip python3Packages.virtualenv 
        python3Packages.pip-tools python3Packages.black
        python3Packages.flake8 python3Packages.mypy python3Packages.pytest
        yarn typescript eslint prettier go-tools rust-analyzer
        cargo-edit cargo-watch cargo-audit cargo-outdated
        # Nix tools
        nixpkgs-fmt rnix-lsp
      ];

      shellHook = ''
        # Set up development environment
        export PYTHONPATH="${pkgs.python3Packages.pip}/lib/python3.11/site-packages:$PYTHONPATH"
        export GOPATH="$HOME/.go"
        export PATH="$GOPATH/bin:$PATH"
        export RUSTUP_HOME="$HOME/.rustup"
        export CARGO_HOME="$HOME/.cargo"
        export PATH="$CARGO_HOME/bin:$PATH"
      '';
    };
  };
} 