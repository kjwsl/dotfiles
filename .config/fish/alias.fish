alias v='nvim'
alias v.='nvim .'

alias g='git'

function vf
    nvim (fzf -m --preview 'bat --style=numbers --color=always {}')
end


bind \cf vf
