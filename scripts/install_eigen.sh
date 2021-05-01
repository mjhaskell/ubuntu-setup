#!/bin/sh

echo_blue "installing eigen tag 3.3.7"

# Ubuntu 20.04 is on 3.3.7
sudo apt install -y libeigen3-dev

# CUR_DIR="$(pwd)"

# mkdir ~/software/eigen3
# cd ~/software/eigen3
# git clone https://gitlab.com/libeigen/eigen.git
# cd eigen
# git checkout tags/3.3.7
# mkdir build && cd build
# cmake ..
# sudo make install

# cd $CUR_DIR

echo_green "eigen installed"
