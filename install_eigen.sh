#!/bin/bash

echo_blue "installing eigen"

mkdir ~/software/eigen3
cd ~/software/eigen3
git clone https://github.com/eigenteam/eigen-git-mirror.git
cd eigen-git-mirror
git checkout tags/3.3.5
mkdir build && cd build
cmake ..
sudo make install

cd ~/scripts

echo_green "eigen installed"
