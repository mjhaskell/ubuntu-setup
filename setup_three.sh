#!/bin/bash

#bash install_debs.sh

echo_blue "autoremove old linux kernals"
sudo apt autoremove
echo_green "autoremove complete"

echo_red "switching to zsh"
bash install_ohmyzsh.sh

