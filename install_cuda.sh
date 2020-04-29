#!/bin/sh

if lspci -v | grep VGA | grep -q NVIDIA; then
    echo_blue "Getting NVIDIA graphics drivers"
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt update

################################################################################
#  This section of the script came from https://developer.nvidia.com/cuda-downloads
#  It will need to be updated as newer versions come out
    echo_blue "installing cuda"
    mkdir ~/software/cuda
    cd ~/software/cuda
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    wget -O cuda_install.deb http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
    sudo apt install ./cuda_install.deb
    sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
    sudo apt update
    sudo apt -y install cuda
################################################################################
        
    echo_green "Cuda installed. After reboot, check that it worked"
    echo_red "Need to power off. Hit ENTER when ready: \c"
    read REPLY
    systemctl poweroff 
else
    echo_blue "No NVIDIA GPU found - not installing cuda"
fi
