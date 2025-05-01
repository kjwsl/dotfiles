{
  description = "A Nix-based development environment configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nix-darwin }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        username = builtins.getEnv "USER";
        homeDirectory = builtins.getEnv "HOME";
      in {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./modules/home-manager/home.nix
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "23.11";
              };
            }
          ];
        };

        # Define activationPackage for home-manager
        packages.${system} = {
          homeConfigurations.${username}.activationPackage = 
            self.homeConfigurations.${username}.activationPackage;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
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

            # Version managers
            nixpkgs-fmt
            rnix-lsp
          ];

          shellHook = ''
            # Set up development environment
            export PYTHONPATH="${pkgs.python3Packages.pip}/lib/python3.11/site-packages:$PYTHONPATH"
            
            # Set up Go environment
            export GOPATH="$HOME/.go"
            export PATH="$GOPATH/bin:$PATH"
            
            # Set up Rust environment
            export RUSTUP_HOME="$HOME/.rustup"
            export CARGO_HOME="$HOME/.cargo"
            export PATH="$CARGO_HOME/bin:$PATH"
          '';
        };

        # Darwin-specific configuration
        darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./modules/nix/default.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = {
                  imports = [ ./modules/home-manager/home.nix ];
                  home = {
                    inherit username homeDirectory;
                    stateVersion = "23.11";
                  };
                };
              };
            }
          ];
        };
      }
    );
} 