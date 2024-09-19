#!/bin/bash
fcitx5-remote -n | sed 's/keyboard-//' | tr [:lower:] [:upper:]

