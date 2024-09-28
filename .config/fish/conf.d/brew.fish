if type -q /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
    #export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
end
