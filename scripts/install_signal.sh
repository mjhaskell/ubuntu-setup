#!/bin/sh

# Instructions came from signal.org/en/download/#

# 1. Install official public software signing key
echo_blue "Getting key"
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
sudo mv signal-desktop-keyring.gpg /usr/share/keyrings/

# 2. Add repo to list of repos
echo_blue "Adding repo to apt"
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

# 3. Update package database and install
sudo apt update
echo_blue "Installing Signal Desktop"
sudo apt install signal-desktop

echo_green "Signal Desktop Installed"

