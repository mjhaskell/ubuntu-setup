#!/bin/bash

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
    wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-ubuntu1804-10-1-local-10.1.243-418.87.00_1.0-1_amd64.deb
    sudo apt install ./cuda-repo-ubuntu1804-10-1-local-10.1.243-418.87.00_1.0-1_amd64.deb
    sudo apt-key add /var/cuda-repo-10-1-local-10.1.243-418.87.00/7fa2af80.pub
    sudo apt update
    sudo apt -y install cuda
################################################################################
        
    cd ~/scripts

    str=$(grep -o 'X Driver...........' /var/log/Xorg.0.log)
    version=$(echo $str | cut -c11-19)

    # check that NVIDIA driver version matches the deb file above
    if [ "$version" = "418.87.00" ]; then
        echo_purple "NVIDIA driver version: $version"
        echo_purple "CUDA version: 10.1.243"
        echo_green "cuda installed"
    else
        echo_red "[ERROR] NVIDIA driver version is not 418.87.00"
        echo_red "\tCheck CUDA and NVIDIA driver installations"
    fi 
else
    echo_blue "No NVIDIA GPU found - not installing cuda"
fi
