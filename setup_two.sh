#!/bin/bash

bash install_pips.sh
bash install_opencv.sh
bash install_ros_melodic.sh

echo_red "computer will now power off"
reboot
