#!/bin/bash

echo_blue "installing osqp"

cd ~/software
git clone --recursive https://github.com/oxfordcontrol/osqp
cd osqp
mkdir build
cd build
cmake -G "Unix Makefiles" ..
cmake --build .
sudo cmake --build . --target install
cd ~/scripts

echo_green "osqp installed"
