#!/bin/sh

echo_blue "installing eigen tag 3.3.7"

mkdir ~/software/eigen3
cd ~/software/eigen3
git clone https://gitlab.com/libeigen/eigen.git 
cd eigen
git checkout tags/3.3.7
mkdir build && cd build
cmake ..
sudo make install

cd ~/scripts

echo_green "eigen installed"
