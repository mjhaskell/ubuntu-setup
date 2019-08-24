#!/bin/bash

#bash install_debs.sh

echo_blue "autoremove old linux kernals"
sudo apt autoremove
echo_green "autoremove complete"

./setup_zsh.sh

