#!/bin/sh

# print cuda information
nvidia-smi
cat /usr/local/cuda/version.txt

# print nvcc version
nvcc --version | grep release

#str=$(grep -o 'X Driver...........' /var/log/Xorg.0.log)
str=$(grep -o 'X Driver...........' ~/.local/share/xorg/Xorg.0.log)
version=$(echo $str | cut -c10-19) # might have to change if not 9 chars

if [ -z "$str" ]; then
    echo_red "[Error] No nvidia drivers found"
    echo_purple "\tCheck CUDA and NVIDIA driver installations"
else
    echo_blue "Nvidia driver version found is $version"
    echo_green "Cuda installed successfully"
fi

