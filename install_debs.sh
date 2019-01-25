#!/bin/bash

echo_blue "installing .deb applications"

sudo apt install gdebi

wget -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi google-chrome.deb
echo_green "google chrome installed"

wget -O mendeley.deb https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest
sudo gdebi mendeley.deb
echo_green "mendeley installed"

wget -O slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-3.1.0-amd64.deb"
sudo gdebi slack.deb
echo_green "slack installed"
