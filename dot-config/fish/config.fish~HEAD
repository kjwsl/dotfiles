if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias ls="ls -a --color"
alias ll="ls -al --color"
alias bat='batcat'

alias vim='nvim'
alias v='nvim'

if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease
    set -x BROWSER wslview
end

zoxide init fish | source

fastfetch
