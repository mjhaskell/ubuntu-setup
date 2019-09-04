#!/bin/bash

echo_blue "installing .deb applications"
echo_red "Check if debs are up-to-date"

wget -O ~/software/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ~/software/google-chrome.deb
echo_green "google chrome installed"

wget -O ~/software/mendeley.deb https://www.mendeley.com/repositories/ubuntu/stable/amd64/mendeleydesktop-latest
sudo apt install ~/software/mendeley.deb
echo_green "mendeley installed"

wget -O ~/software/slack.deb "https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb"
sudo apt install ~/software/slack.deb
echo_green "slack installed"

sudo apt install -f
