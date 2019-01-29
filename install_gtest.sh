#!/bin/bash

echo_blue "Installing Google Test"

sudo apt install libgtest-dev
cd /usr/src/gtest/
sudo mkdir build
cd build
sudo cmake ..
sudo make
sudo cp *.a /usr/lib
sudo mkdir /usr/local/lib/gtest
sudo ln -s /usr/lib/libgtest.a /usr/local/lib/gtest/
sudo ln -s /usr/lib/libgtest_main.a /usr/local/lib/gtest/
cd ..
sudo rm -rf build
cd ~/scripts/

echo_green "Google Test Installed"
