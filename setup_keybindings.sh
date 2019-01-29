#!/bin/bash

echo_blue "Setting up keybindings"

alias keybind='gsettings set org.gnome.desktop.wm.keybindings'
keybind switch-to-workspace-1 "['<ctrl><super>1']"

echo_green "Keybindings set up"
