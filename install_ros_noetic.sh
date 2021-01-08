#!/bin/sh

#Install ROS
echo_blue "Installing ROS Melodic for Ubuntu 18.04 based off of wiki.ros.org installation guide"

echo_blue "Setup your sources.list"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

echo_blue "Set up up your keys"
# this key could change if ROS ever updates it for whatever reason
# sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo -E apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

echo_blue "Installation"

sudo apt update
sudo apt install -y ros-melodic-desktop-full

echo_blue "Initialize rosdep"

sudo rosdep init
rosdep update

echo_blue "Installing final dependencies"

sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool
sudo apt install -y ros-melodic-eigen-stl-containers
sudo apt install -y python3-catkin-pkg-modules python3-rospkg-modules

echo_green "ROS Melodic installed"
