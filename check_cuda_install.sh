#!/bin/sh

# print cuda information
nvidia-smi

str=$(grep -o 'X Driver...........' /var/log/Xorg.0.log)
version=$(echo $str | cut -c10-19)

# check that NVIDIA driver version matches cuda install instructions
if [ "$version" = "440.33.01" ]; then
    echo_blue "NVIDIA driver version: $version"
    echo_blue "CUDA version: 10.2.89"
    echo_green "cuda installed"
else
    echo_red "[ERROR] NVIDIA driver version is not 440.33.01"
    echo_red "\tCheck CUDA and NVIDIA driver installations"
fi
