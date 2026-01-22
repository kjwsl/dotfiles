function pi
    if type -q pacman
        sudo pacman -S --needed --noconfirm $argv
    end
end
