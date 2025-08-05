# config.nu
#
# Installed by:
# version = "0.106.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# Set the default editor to use

$env.config.buffer_editor = "nvim"

source ~/.config/nushell/aliases.nu

source ~/.zoxide.nu

source ~/.config/nushell/themes/catppuccin_mocha.nu

oh-my-posh init nu --config 'agnoster'
# oh-my-posh init nu --config 'catppuccin'
# oh-my-posh init nu --config 'catppuccin_mocha'
# oh-my-posh init nu --config 'stelbent-compact.minimal'
# oh-my-posh init nu --config 'fish'
