if status is-interactive
    # Core settings
    export EDITOR="nvim"
    export VISUAL=$EDITOR

    # Paths
    export PATH="$HOME/.local/bin:$PATH"
    fish_add_path "$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin/"
    fish_add_path "$HOME/.cargo/bin/"
    export PKG_CONFIG_PATH="$HOME/.luarocks/share/lua/5.1:$HOME/.nix-profile/bin:$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

    # Plugin Manager (Fisher) - Automatic Installation
    if not type -q fisher
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end

    if not type -q bass
        fisher install edc/bass
    end

    # Load Aliases
    if test -f $HOME/.config/fish/alias.fish
        source $HOME/.config/fish/alias.fish
    end

    # Environment Loading
    if test -f $HOME/.envrc
        bass source $HOME/.envrc
    end

    if test -d $HOME/modules
        for file in $HOME/modules/*.sh
            bass source $file
        end
    end

    alias fish_reload="source $HOME/.config/fish/config.fish"

    # Tool Initializations
    if type -q pyenv 
          set -Ux PYENV_ROOT $HOME/.pyenv
          fish_add_path $PYENV_ROOT/bin
          pyenv init - fish | source
    end

    if type -q starship
        starship init fish | source
    end
    
    # Note: zoxide is initialized by the kidonng/zoxide.fish plugin

    alias zo="z (dirname (fzf))"

    if type -q eza
        alias ls="eza --icons --group-directories-first -a"
        alias ll="eza --icons --group-directories-first -la"
    end

    # System Info
    if type -q fastfetch
        fastfetch
    else if type -q neofetch
        neofetch
    end

    # Secrets and Work
    if test -f $HOME/.secrets
        envsource $HOME/.secrets
    end

    if test -f $HOME/work.fish
        source $HOME/work.fish
    end
end