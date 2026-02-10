if status is-interactive
    # Core settings
    export EDITOR="nvim"
    export VISUAL=$EDITOR

    # Plugin Manager (Fisher) - Automatic Installation
    if not type -q fisher
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher $plugins
    end

    # Enable transient prompt
    set -g fish_transient_prompt 1

    # Paths
    export PATH="$HOME/.local/bin:$PATH"
    fish_add_path "$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin/"
    fish_add_path "$HOME/.cargo/bin/"
    export PKG_CONFIG_PATH="$HOME/.luarocks/share/lua/5.1:$HOME/.nix-profile/bin:$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

    # Load Aliases
    if test -f $__fish_config_dir/alias.fish
        source $__fish_config_dir/alias.fish
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

    alias fish_reload="source $__fish_config_dir/config.fish"

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

    # System Info (disabled for performance - use 'fastfetch' command to run on demand)
    # if type -q fastfetch
    #     fastfetch
    # else if type -q neofetch
    #     neofetch
    # end

    # Secrets and Work
    if test -f $HOME/.secrets
        envsource $HOME/.secrets
    end

    if test -f $HOME/work.fish
        source $HOME/work.fish
    end

    fish_vi_key_bindings

    # ntfy.sh notifications
    set -gx NTFY_TOPIC notify-3152210757

    function notify
        set -l msg (test (count $argv) -gt 0; and string join " " $argv; or echo "Task completed")
        set -l dir (string replace $HOME "~" $PWD)
        curl -s \
            -H "Title: 🔔 $hostname: Manual notification" \
            -d "$msg

Directory: $dir" \
            "ntfy.sh/$NTFY_TOPIC" >/dev/null 2>&1 &
    end

    # Auto-notify for commands taking longer than 10 seconds
    function __notify_on_long_command --on-event fish_postexec
        # Skip for interactive editors and common long-running interactive tools
        set -l command_name (string split -m 1 " " $argv[1])[1]
        if contains $command_name nvim vi vim ssh hx btop
            return
        end
        if test $CMD_DURATION -gt 30000
            set -l secs (math "$CMD_DURATION / 1000")
            set -l status_emoji (test $status -eq 0 && echo "✅" || echo "❌")
            set -l status_text (test $status -eq 0 && echo "Success" || echo "Failed (exit $status)")
            set -l cmd (string shorten -m 100 "$argv[1]")
            set -l dir (string replace $HOME "~" $PWD)
            set -l host $hostname
            curl -s \
                -H "Title: $status_emoji $host: Command finished" \
                -d "$cmd

Status: $status_text
Duration: $secs seconds
Directory: $dir" \
                "ntfy.sh/$NTFY_TOPIC" >/dev/null 2>&1 &
        end
    end

    # -----------------------------------------------------------------------------
    # Neural Orchestrator Context Integration
    # -----------------------------------------------------------------------------
    # Dynamically add the Context Vault's function library if it exists.
    # This avoids manual symlinking and keeps the system portable.
    if test -d $HOME/.context/integrations/fish
        set -p fish_function_path $HOME/.context/integrations/fish
        # Only source if the file actually exists
        if test -f $HOME/.context/integrations/fish/gemini-profiles.fish
            source $HOME/.context/integrations/fish/gemini-profiles.fish
        end
    end
end
