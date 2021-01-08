#!/bin/sh

#Install ROS
echo_blue "Installing ROS Noetic for Ubuntu 20.04 based off of wiki.ros.org installation guide"

echo_blue "Setup your sources.list"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

echo_blue "Set up up your keys"
# this key could change if ROS ever updates it for whatever reason
sudo -E apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

echo_blue "Installation"

sudo apt update
sudo apt install -y ros-noetic-desktop #-full

echo_blue "Initialize rosdep"

#sudo apt install python3-rosdep
#sudo rosdep init
#rosdep update

echo_blue "Installing final dependencies"

sudo apt install -y python3-rosinstall python3-rosinstall-generator
sudo apt install -y ros-noetic-eigen-stl-containers

echo_green "ROS Noetic installed"
