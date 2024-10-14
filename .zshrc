# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

## Aliases
if [[ -f $HOME/.aliasrc ]]; then
    source $HOME/.aliasrc;
fi

## Environment Variables

if [[ -f $HOME/.envrc ]]; then
    source $HOME/.envrc;
fi



# Plugins

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma-continuum/history-search-multi-word

# Two regular plugins loaded without investigating.
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice depth=1; zinit light romkatv/powerlevel10k

# Path to the timestamp file
zinit_update_stamp="$HOME/.zinit_last_update"

# Check if the file exists, and if not, create it with the current date
if [[ ! -f "$zinit_update_stamp" ]]; then
    date +%s > "$zinit_update_stamp"
fi

# Calculate how many days have passed since the last update
last_update=$(cat "$zinit_update_stamp")
current_time=$(date +%s)
# 86400 seconds in a day
days_passed=$(( (current_time - last_update) / 86400 ))

# If 15 days have passed, run zinit update and update the timestamp
if [[ $days_passed -ge 15 ]]; then
    echo "Updating zinit..."
    zinit self-update
    zinit update --parallel
    date +%s > "$zinit_update_stamp"
fi

## Modules

if [[ -d $HOME/modules ]]; then
    for file in $HOME/modules/*.sh; do
        source $file;
    done
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
