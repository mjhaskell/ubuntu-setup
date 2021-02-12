#!/bin/sh

if lspci -v | grep -i 'VGA\|3d\|2d' | grep -q NVIDIA; then
    mkdir -p ~/software/cuda
    cd ~/software/cuda

    echo_blue "Saving online instructions to web_instruction.sh"
    echo ''

    echo '#!/bin/sh' > web_instructions.sh
    echo '' >> web_instructions.sh
    curl --silent "https://developer.nvidia.com/cuda-downloads" | 
        grep -n Linux/x86_64/Ubuntu/20.04/ | # specific to Ubuntu 20.04
        grep -n /cuda-repo-ubuntu2004 | # specific to Ubuntu 20.04
        grep -oP '(?<="cudaBash">).+?(?=</span>)' >> web_instructions.sh
    sed -i 's/dpkg -i&nbsp;/apt install .\//' web_instructions.sh
    sed -i 's/apt-get/apt/' web_instructions.sh

    echo_blue "This is the file that was created: "
    cat web_instructions.sh

    #  This came from https://developer.nvidia.com/cuda-downloads
    echo_blue "The file should look something like this: "
    echo "
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt install ./cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt update
sudo apt -y install cuda
"
    read -p "Execute the created file? (Y/n): " EXE
    EXE=${EXE:-Y} # Sets Y to be default value if EXE is empty
    case $EXE in
        [yY]* ) # if first letter is y or Y (yes)
            echo_blue "installing cuda"
            sh ~/software/cuda/web_instructions.sh
            cd ~/scripts
            echo_green "Cuda installed"
            echo_purple "After reboot, check that it worked"
            echo "(might have to change bios settings to use GPU)"
            echo_red "Need to power off. Hit ENTER when ready: \c"
            read REPLY
            systemctl poweroff;;
        * ) # anything else
            echo "Not executing file";;
    esac

else
    echo_blue "No NVIDIA GPU found - not installing cuda"
fi
