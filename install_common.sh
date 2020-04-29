#!/bin/sh

sudo apt update
sudo apt upgrade

echo_blue "installing common"

sudo apt install -y git zsh curl htop ssh gcc cmake ccache make gdb
sudo apt install -y tmux xclip qpdfview shotwell unzip
sudo apt install -y build-essential manpages-dev software-properties-common
sudo apt install -y exfat-utils exfat-fuse
sudo apt install -y python-dev python-pip python3-dev python3-pip python3-tk
sudo apt install -y pybind11-dev libtool  
sudo apt install -y libffi6 libffi-dev 
sudo apt install -y nmap cifs-utils
sudo apt install -y simplescreenrecorder vlc ffmpeg
sudo apt install -y libcanberra-gtk-module mesa-utils mesa-utils-extra

# sudo apt install libeigen3-dev

if [ ! -d ~/software ]; then mkdir ~/software; fi

echo_green "common installed"

sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER

echo_green "user added to common groups"
