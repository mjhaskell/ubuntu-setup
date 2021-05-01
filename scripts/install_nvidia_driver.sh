#!/bin/sh

sudo apt install -y ubuntu-drivers-common

if ! ls /etc/apt/sources.list.d/ | grep -q graphics-drivers; then
    echo_blue "Getting NVIDIA graphics drivers from ppa"
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt update
    sudo apt install nvidia-prime
fi

# check nvidia driver info
if sudo lshw -c video | grep -q driver=nouveau; then
    echo_blue "Listing available NVIDIA drivers"
    sudo ubuntu-drivers devices
    read -p "Install recommended version? (Y/n): " REC
    REC=${REC:-Y} # set default value to Y
    case $REC in
        [yY]* ) # if yes
            echo_blue "Installing recommended NVIDIA driver"
            sudo ubuntu-drivers autoinstall
            echo_green "Switched to recommended NVIDIA driver"
            echo_red "Need to power off. Hit ENTER when ready: \c"
            read REPLY
            systemctl poweroff;;
        * ) # any other answer
            echo_purple "Install driver with" 
            echo_purple "\tsudo apt install nvidia-driver-###'"
            echo_red "NOTE: must poweroff after changing NVIDIA drivers";;
    esac
else
    echo_blue "Already using NVIDIA driver. Please check the current version:"
    nvidia-smi | grep "Driver Version"
    echo_blue "These are the available NVIDIA driver versions:"
    sudo ubuntu-drivers devices
fi

