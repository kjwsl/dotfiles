if status is-interactive
    # Commands to run in interactive sessions can go here

    if not type -q fisher
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end

    if not type -q bass
        fisher install edc/bass
    end

    if [ -f $HOME/.aliasrc ]
        bass source $HOME/.aliasrc
    end

    if [ -f $HOME/.envrc ]
        bass source $HOME/.envrc
    end

    if [ -d $HOME/modules ]
        for file in $HOME/modules/*.sh
            bass source $file
        end
    end

    alias fish_reload="source $HOME/.config/fish/config.fish"

    export EDITOR="nvim"
    export VISUAL=$EDITOR
    export PATH="$HOME/.local/bin:$PATH"
    export PKG_CONFIG_PATH="$HOME/.luarocks/share/lua/5.1:$HOME/.nix-profile/bin:$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

    if uname -o | grep -q "GNU/Linux"
        set glibc_version (ldd --version | head -n 1 | awk '{print $NF}')
        if test $glibc_version -lt 2.33
            if type -q neofetch
                neofetch
            end
        else
            if type -q fastfetch
                fastfetch
            end
        end
    else
        if type -q fastfetch
            fastfetch
        else if type -q neofetch
            neofetch
        end
    end

    if type -q zoxide
        zoxide init fish | source
    end

    alias zo="z (dirname (fzf))"
end

