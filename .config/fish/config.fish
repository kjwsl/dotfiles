if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ls="ls -a --color"
    alias ll="ls -al --color"
    alias vim="nvim"
    alias v="nvim"
    alias v.="nvim ."
    alias fish_reload="source $HOME/.config/fish/config.fish"

    export EDITOR="nvim"
    export VISUAL=$EDITOR
    export PATH="$HOME/.local/bin:$PATH"
    export PKG_CONFIG_PATH="$HOME/.luarocks/share/lua/5.1:$HOME/.nix-profile/bin:$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q fastfetch
        fastfetch
    end
end

