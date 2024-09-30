if status is-interactive
    # Commands to run in interactive sessions can go here
    alias ls="ls -a --color"
    alias ll="ls -al --color"
    alias vim="nvim"
    alias v="nvim"
    alias "v."="nvim ."

    if type -q zoxide
        zoxide init fish | source
    end

    if type -q fastfetch
        fastfetch
    end

    if type -q /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv
    end
end

