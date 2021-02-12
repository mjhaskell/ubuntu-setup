#!/bin/sh

sudo apt install -y python3-catkin-pkg-modules python3-rospkg-modules
pip3 uninstall em
pip3 install empy
pip3 install posix_ipc pyyaml catkin-pkg pygame

cd ~/
if [ ! -d ~/holodeck_ws ]; then
    mkdir ~/holodeck_ws
fi
cd holodeck_ws

if [ ! -d src ]; then 
    mkdir src
fi
cd src

if [ ! -h CMakeLists.txt ]; then
    echo_blue "Initializing holodeck_ws"
    catkin_init_workspace
fi

if [ ! -d rosflight ]; then
    echo_blue "Cloning rosflight package into holodeck_ws"
    git clone --recursive https://github.com/rosflight/rosflight.git 
fi

if [ ! -d rosflight_joy ]; then
    echo_blue "Cloning rosflight_joy package into holodeck_ws"
    git clone --recursive https://github.com/rosflight/rosflight_joy.git 
fi

if [ ! -d roscopter ]; then
    echo_blue "Cloning roscopter package into holodeck_ws"
    git clone --recursive https://github.com/byu-magicc/roscopter.git 
fi

if [ ! -d rosflight_holodeck ]; then
    echo_blue "Cloning rosflight_holodeck package into holodeck_ws"
    git clone --recursive https://magiccvs.byu.edu/gitlab/lab/rosflight_holodeck.git
fi

echo_blue "Building holodeck_ws"
cd ~/holodeck_ws 
catkin_make 

echo_blue "Building Holodeck"
cd src/rosflight_holodeck/python/holodeck
pip3 install --prefix=~/.local -e .

cd ~/scripts

echo_blue "Installing Holodeck worlds"
python3 install_holodeck_worlds.py

echo_green "Holodeck installed"

