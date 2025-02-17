alias v='nvim'
alias v.='nvim .'

alias g='git'

function vf
    nvim (fzf --preview 'bat --style=numbers --color=always {}')
end
