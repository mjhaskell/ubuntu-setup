#!/bin/sh

#Install ROS
echo_blue "Installing ROS Humble for Ubuntu 22.04 based off of https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html installation guide"

echo_blue "Set up up your keys"
sudo apt update && sudo apt install curl gnupg lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo_blue "Setup your sources list"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo_blue "Installation"
sudo apt update
sudo apt upgrade

# dependencies
sudo apt install -y qtbase5-dev qt5-qmake qttools5-dev qttools5-dev-tools
sudo apt install -y qtwebengine5-dev libqt5svg5-dev libqt5websockets5-dev
pip install empy

sudo apt install python3-colcon-common-extensions python3-colcon-argcomplete
sudo apt install -y ros-humble-ros-base ros-humble-rqt-common-plugins
sudo apt install -y ros-humble-rviz2
# sudo apt install -y ros-humble-desktop # wanted to remove budgie

# echo_blue "Initialize rosdep"
# sudo apt install python3-rosdep
# sudo rosdep init
# rosdep update

# echo_blue "Installing final dependencies"
# sudo apt install -y python3-rosinstall python3-rosinstall-generator
# sudo apt install -y ros-noetic-eigen-stl-containers

echo_green "ROS Humble installed"
