#!/bin/sh

echo_blue "Installing VSCode"

wget -O install_vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
sudo apt install ./install_vscode.deb
rm install_vscode.deb

# C/C++ extension
code --install-extension ms-vscode.cpptools
code --install-extension twxs.cmake

# Python extension
code --install-extension ms-python.python

# Vim extension
code --install-extension vscodevim.vim

# IntelliCode extension
code --install-extension visualstudioexptteam.vscodeintellicode

# Live Share
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension ms-vsliveshare.vsliveshare-audio

echo_green "VSCode installed with extensions"

