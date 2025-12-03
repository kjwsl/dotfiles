function envsource
    for line in (cat $argv | grep -v '^#')
        set item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
    end
end

function pi
    if type -q pacman
        sudo pacman -S --needed --noconfirm $argv
    end
end
