#!/bin/sh

echo_blue "installing osqp-eigen"

CUR_DIR="$(pwd)"
cd ~/software
git clone https://github.com/robotology/osqp-eigen.git
cd osqp-eigen
mkdir build
cd build
cmake ..
make
sudo make install
cd $CUR_DIR

echo_green "osqp-eigen installed"
