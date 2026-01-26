if status is-interactive
    # Core settings
    export EDITOR="nvim"
    export VISUAL=$EDITOR

    # Enable transient prompt
    set -g fish_transient_prompt 1

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
    
    # Initialize zoxide (fallback if plugin fails)
    if type -q zoxide
        zoxide init fish | source
    end

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

    fish_vi_key_bindings

    # ntfy.sh notifications
    set -gx NTFY_TOPIC "notify-3152210757"

    function notify
        set -l msg (test (count $argv) -gt 0; and string join " " $argv; or echo "Task completed")
        curl -s -d "$msg" "ntfy.sh/$NTFY_TOPIC" >/dev/null 2>&1 &
    end

    # Auto-notify for commands taking longer than 10 seconds
    function __notify_on_long_command --on-event fish_postexec
        if test $CMD_DURATION -gt 10000
            set -l secs (math "$CMD_DURATION / 1000")
            set -l cmd (string shorten -m 50 "$argv[1]")
            curl -s -d "$cmd finished ($secs s)" "ntfy.sh/$NTFY_TOPIC" >/dev/null 2>&1 &
        end
    end
end
