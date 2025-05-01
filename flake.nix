{
  description = "A hybrid Nix and Ansible configuration for system and development environments";

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

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Development tools
            ansible
            python3
            python3Packages.pip
            git
            neovim
            tmux
            htop

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

            # Language tools
            nodejs
            go
            rustc
            cargo
            gcc
            clang
            cmake
            pkg-config

            # Version managers
            nixpkgs-fmt
            rnix-lsp
          ];

          shellHook = ''
            # Set up development environment
            export PYTHONPATH="${pkgs.python3Packages.pip}/lib/python3.11/site-packages:$PYTHONPATH"
            export PATH="$HOME/.dev/pyenv/bin:$HOME/.dev/nvm:$HOME/.dev/go/bin:$PATH"
            
            # Initialize version managers if they exist
            if [ -d "$HOME/.dev/pyenv" ]; then
              export PYENV_ROOT="$HOME/.dev/pyenv"
              eval "$(pyenv init --path)"
            fi
            
            if [ -d "$HOME/.dev/nvm" ]; then
              export NVM_DIR="$HOME/.dev/nvm"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            fi
            
            if [ -d "$HOME/.dev/go" ]; then
              export GOPATH="$HOME/.dev/go"
              export PATH="$GOPATH/bin:$PATH"
            fi
            
            # Set up Rust environment
            if [ -d "$HOME/.cargo" ]; then
              source "$HOME/.cargo/env"
            fi
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