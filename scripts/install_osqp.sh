#!/bin/sh

echo_blue "installing osqp"

CUR_DIR="$(pwd)"
cd ~/software
git clone --recursive https://github.com/oxfordcontrol/osqp
cd osqp
mkdir build
cd build
cmake -G "Unix Makefiles" ..
cmake --build .
sudo cmake --build . --target install
cd $CUR_DIR

echo_green "osqp installed"
