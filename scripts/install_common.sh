#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "installing common"

sudo apt update
sudo apt upgrade -y

# sudo dpkg --remove-architecture i386
# sudo apt update
# sudo apt upgrade

# create my common folder structure
if [ ! -d $HOME/software ]; then mkdir $HOME/software; fi
if [ ! -d $HOME/bin ]; then mkdir $HOME/bin; fi
if [ ! -d $HOME/tmp ]; then mkdir $HOME/tmp; fi
if [ ! -d $HOME/scratch ]; then mkdir $HOME/scratch; fi

# install color functions
sudo cp $SETUP_DIR/bin/color_functions/echo_* /usr/local/bin/
echo_green "Color functions installed"

# set password for root
echo_blue "Creating password for root"
sudo passwd root

# network (use 'sudo nmtui' to configure wifi)
# sudo systemctl disable systemd-networkd.service
# sudo apt install -y network-manager nmap
sudo apt install -y nmap

# terminal
sudo apt install -y git zsh curl htop ssh # htop already installed
sudo apt install -y bat ripgrep fd-find
# sudo apt install -y manpages-dev software-properties-common # already installed
# sudo apt install -y xterm rxvt-unicode
sudo apt install -y tmux xclip unzip # unzip already installed
# sudo apt install -y xclip unzip
sudo apt install -y fonts-emojione

# graphics
# mesa-utils-extra no longer exists
# mesa-utils already installed
sudo apt install -y mesa-utils # mesa-utils-extra

# sounds
sudo apt install -y libcanberra-gtk-module
sudo apt install -y alsa-base alsa-utils # already installed

# printers
sudo apt install -y hplip # already installed

# windows file system (fs)
sudo apt install -y ntfs-3g # already installed
# tools for mounting J-drive
sudo apt install -y cifs-utils

# C++
sudo apt install -y build-essential gcc g++ gcc-14 g++-14 gdb libstdc++-14 # already installed
# clang (default) gives v18
sudo apt install -y clang-19 lldb-19 lld-19
sudo apt install -y libc++-19-dev libclang-19-dev libllvm-19-ocaml-dev
sudo apt install -y libomp-19-dev python3-clang-19
sudo apt install -y cmake ccache make cmake-curses-gui ninja-build
# set up compiler versions (last # is priority - highest is default)
# change compilers with `sudo update-alternatives --config <g++>`
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 13
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 13
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 14
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-14 14
echo_yellow "G++ compiler information:"
sudo update-alternatives --display g++

sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 18
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 18
sudo update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-18 18
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-19 19
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-19 19
sudo update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-19 19
echo_yellow "G++ compiler information:"
sudo update-alternatives --display clang++

# python deps
sudo apt install -y python3-dev python3-venv # python3-tk
sudo apt install -y pybind11-dev libtool libffi-dev
# create default virtual environment
if [ ! -d $HOME/.pyvenvs ]; then
  echo_blue "creating python global venv"
  mkdir $HOME/.pyvenvs
  python3 -m venv ${HOME}/.pyvenvs/default
fi

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
 
# pdf, image, and video viewers
# sudo apt install -y qpdfview
# sudo apt install -y zathura
# sudo apt install -y shotwell
sudo apt install -y vlc ffmpeg

# screenshot and screen recording
sudo apt install -y flameshot
# sudo apt install -y simplescreenrecorder

echo_green "common installed"

# add user to groups
sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER
sudo usermod -a -G video $USER

echo_green "user added to common groups"

# set the timezone
sudo timedatectl set-timezone America/Denver

echo_green "timezone set to MDT"
