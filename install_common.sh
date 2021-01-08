#!/bin/sh

sudo apt update
sudo apt upgrade

sudo cp color_functions/echo_* /usr/local/bin
echo_green "Color functions installed"

# set password for root
echo_blue "Creating password for root"
sudo passwd root

echo_blue "installing common"

# network (use 'sudo nmtui' to configure wifi)
sudo systemctl disable systemd-networkd.service
sudo apt install -y network-manager nmap cifs-utils

# terminal
sudo apt install -y git zsh curl htop ssh 
sudo apt install -y manpages-dev software-properties-common
sudo apt install -y xterm rxvt-unicode
sudo apt install -y tmux xclip unzip
sudo apt install -y fonts-emojione

# graphics
sudo apt install -y mesa-utils mesa-utils-extra

# sounds
sudo apt install -y libcanberra-gtk-module
sudo apt install -y alsa-base alsa-utils

# windows file system (fs)
sudo apt install -y ntfs-3g

# C++
sudo apt install -y build-essential gcc g++ gcc-10 g++-10 cmake ccache make gdb
# set up compiler versions (last # is priority - highest is default)
# change compilers with `sudo update-alternatives --config <g++>`
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
echo_yellow "G++ compiler information:"
sudo update-alternatives --display g++

# python deps
sudo apt install -y python3-dev python3-venv
sudo apt install -y pybind11-dev libtool libffi-dev
# pygame deps
sudo apt install -y libfreetype-dev libsdl-image1.2-dev libsdl-mixer1.2-dev
sudo apt install -y libsdl1.2-dev libsdl-ttf2.0-dev libportmidi-dev

# pdf, image, and video viewers
sudo apt install -y qpdfview shotwell vlc ffmpeg

# screenshot and screen recording
sudo apt install -y gnome-screenshot simplescreenrecorder 

echo_green "common installed"

# create my common folder structure
if [ ! -d ~/software ]; then mkdir ~/software; fi
if [ ! -d ~/bin ]; then mkdir ~/bin; fi

# add user to groups
sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER
sudo usermod -a -G video $USER

echo_green "user added to common groups"

# set the timezone
sudo timedatectl set-timezone America/Denver

echo_green "timezone set to MDT"
