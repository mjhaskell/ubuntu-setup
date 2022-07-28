#!/bin/sh

echo_blue "Installing PX4 SITL"

CUR_DIR="$(pwd)"

sudo apt install -y openjdk-11-jdk

# install Gradle 6.3 (don't use apt!)
# https://gradle.org/install/
cd ~/software
mkdir gradle
wget https://services.gradle.org/distributions/gradle-6.3-bin.zip
sudo mkdir /opt/gradle
sudo unzip -d /opt/gradle gradle-6.3-bin.zip
if [ -d /opt/gradle ]; then
    if ! echo $PATH | grep -q /opt/gradle; then
        export PATH=/opt/gradle/gradle-6.3/bin:$PATH
    fi
fi
gradle -v

# setup ROS2 workspace for RTPS bridge (ROS2 and PX4 comm interface)
# https://docs.px4.io/main/en/ros/ros2_comm.html#build-ros-2-workspace
mkdir -p ~/px4_ros_com_ros2/src
git clone https://github.com/PX4/px4_ros_com.git ~/px4_ros_com_ros2/src/px4_ros_com
git clone https://github.com/PX4/px4_msgs.git ~/px4_ros_com_ros2/src/px4_msgs

# install PX4-STIL
# https://microsoft.github.io/AirSim/px4_sitl/
cd ~/software
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
bash ./PX4-Autopilot/Tools/setup/ubuntu.sh --no-nuttx --no-sim-tools
cd PX4-Autopilot
# git checkout $(curl --silent "https://api.github.com/repos/PX4/PX4-Autopilot/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
# can't use latest stable release (at least as of now on v1.13.0)
# https://github.com/PX4/PX4-Autopilot/issues/19917 last comment here tells fix
git fetch
git checkout 10a2b4c9f7d34234459b4d3604b99a33491a9d83
git submodule update --init --recursive
# make px4_sitl_default none_iris

# install RTPS bridge
if gradle -v | grep -q "Gradle 6.3"; then
  # https://docs.px4.io/main/en/dev_setup/fast-dds-installation.html
  cd ~/software
  git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git -b v1.0.4 Fast-RTPS-Gen
  cd Fast-RTPS-Gen
  gradle assemble
  sudo env "PATH=$PATH" gradle install

  cd ~/px4_ros_com_ros2/src/px4_ros_com/scripts
  # TODO: need to manually edit the bash script to allow for humble
# TODO: need to #define ROS_DEFAULT_API for px4_ros_com to build
  source build_ros2_workspace.bash
else
  echo_red "Gradle install failed. Fix it and then install Fast-RTPS-Gen"
fi

cd $CUR_DIR

echo_green "PX4 SITL installed"
