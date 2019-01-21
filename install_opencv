#!/bin/bash

# required dependencies before running this file include:
# build-essential cmake git python-dev python-numpy
# (these should already be installed from previous install scripts)

echo_blue "installing dependencies for openCV"

# other required dependencies before installing openCV
sudo apt install libgtk-3-dev pkg-config libavcodec-dev libavformat-dev
sudo apt install libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev
sudo apt install libtiff-dev libjasper-dev libdc1394-22-dev ffmpeg
sudo apt install libv41-dev libxvidcore-dev libx264-dev unzip
sudo apt install libatlas-base-dev gfortran

echo_blue "updating/upgrading apt"

sudo apt update
sudo apt upgrade

echo_blue "downloading openCV-4.0.1"

### Uncomment lines below if you want to install the extra modules
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.1.zip
#wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.1.zip

unzip opencv.zip
#unzip opencv_contrib.zip

mv opencv-4.0.1 opencv
#mv opencv_contrib-4.0.1 opencv_contrib

rm -rf opencv.zip
#rm -rf opencv_contrib.zip

echo_blue "installing openCV, this may take a while"

cd opencv
mkdir build && cd build

### choose 1 of the following 2 lines (1-default, 2-extra modules)
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_PYTHON_EXAMPLES=OFF -D INSTALL_C_EXAMPLES=OFF -D OPENCV_ENABLE_NONFREE=ON -D BUILD_EXAMPLES=OFF ..
#cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_PYTHON_EXAMPLES=OFF -D INSTALL_C_EXAMPLES=OFF -D OPENCV_ENABLE_NONFREE=ON -D BUILD_EXAMPLES=OFF -D OPENCV_EXTRA_MODULES_PATH=~/scripts/opencv_contrib/modules ..

make -j8
sudo make install

cd ~/scripts

echo_green "openCV was installed"
