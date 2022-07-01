#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

echo_blue "installing common"

sudo apt update
sudo apt upgrade -y

# create my common folder structure
if [ ! -d ~/software ]; then mkdir ~/software; fi
if [ ! -d ~/bin ]; then mkdir ~/bin; fi
if [ ! -d ~/tmp ]; then mkdir ~/tmp; fi

# install color functions
sudo cp $SETUP_DIR/bin/color_functions/echo_* /usr/local/bin/
echo_green "Color functions installed"

# set password for root
echo_blue "Creating password for root"
sudo passwd root

# network (use 'sudo nmtui' to configure wifi)
sudo systemctl disable systemd-networkd.service
sudo apt install -y network-manager nmap

# terminal
sudo apt install -y git zsh curl htop ssh
sudo apt install -y manpages-dev software-properties-common
# sudo apt install -y xterm rxvt-unicode
# sudo apt install -y tmux xclip unzip
sudo apt install -y xclip unzip
sudo apt install -y fonts-emojione

# graphics
sudo apt install -y mesa-utils mesa-utils-extra

# sounds
sudo apt install -y libcanberra-gtk-module
sudo apt install -y alsa-base alsa-utils

# printers
sudo apt install -y hplip

# windows file system (fs)
sudo apt install -y ntfs-3g
# tools for mounting J-drive
sudo apt install -y cifs-utils

# C++
sudo apt install -y build-essential gcc g++ gcc-12 g++-12 gdb
sudo apt install -y cmake ccache make cmake-curses-gui
# set up compiler versions (last # is priority - highest is default)
# change compilers with `sudo update-alternatives --config <g++>`
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 12
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 12
echo_yellow "G++ compiler information:"
sudo update-alternatives --display g++

# python deps
sudo apt install -y python3-dev python3-venv python3-tk
sudo apt install -y pybind11-dev libtool libffi-dev
# create default virtual environment
if [ ! -d ~/.virtualenvs ]; then
    echo_blue "creating python global venv"
    mkdir ~/.virtualenvs
    python3 -m venv ${HOME}/.virtualenvs/default
fi

# pdf, image, and video viewers
# sudo apt install -y qpdfview
sudo apt install -y zathura
sudo apt install -y shotwell
sudo apt install -y vlc ffmpeg

# screenshot and screen recording
sudo apt install -y flameshot
sudo apt install -y simplescreenrecorder

echo_green "common installed"

# add user to groups
sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER
sudo usermod -a -G video $USER

echo_green "user added to common groups"

# set the timezone
sudo timedatectl set-timezone America/Denver

echo_green "timezone set to MDT"
