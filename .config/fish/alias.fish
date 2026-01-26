alias tree='tree -C'
alias v='nvim'
alias v.='nvim .'

alias g='git'

function vf
    nvim (fzf -m --preview 'bat --style=numbers --color=always {}')
end

function zf
    set dir (find . -type d -print | fzf) || return
    z $dir
end


bind \cf zf
