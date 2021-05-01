#!/bin/sh

echo_blue "Installing Zoom"

wget -O ~/software/install_zoom.deb https://byu.zoom.us/client/latest/zoom_amd64.deb
sudo apt install ~/software/install_zoom.deb
rm ~/software/install_zoom.deb

echo_green "Zoom Installation Complete"
