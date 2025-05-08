#!/usr/bin/env bash

source tools.sh

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
safe_cd yay 
makepkg -si || {
    error "Failed to install yay"
}
rm -rf yay
