#!/bin/sh

echo_blue "installing i3"

sudo apt install -y xserver-xorg-input-libinput x11-xserver-utils
sudo add-apt-repository ppa:kgilmer/speed-ricer
sudo apt install -y i3-gaps-wm i3status rofi
sudo apt install -y xinit

echo_green "i3 installed"
