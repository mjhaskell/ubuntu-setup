#!/bin/sh

echo_blue "installing osqp-eigen"

cd ~/software
git clone https://github.com/robotology/osqp-eigen.git
cd osqp-eigen
mkdir build 
cd build
cmake ..
make
sudo make install
cd ~/scripts

echo_green "osqp-eigen installed"
