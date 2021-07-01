#!/bin/sh

echo_blue "installing logiopts"

CUR_DIR="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

# install dependencies
sudo apt install -y libevdev-dev libudev-dev libconfig++-dev

# clone and build repo
cd ~/software
git clone https://github.com/PixlOne/logiops
cd logiops
mkdir build && cd build
cmake ..
make
sudo make install

# add logid config file 
# (see wiki.archlinux.org/title/Logitech_MX_Master for help with config file)
if [ ! -h /etc/logid.cfg ]; then
    if [ -f /etc/logid.cfg ]; then
        sudo mv /etc/logid.cfg /etc/logid.cfg.bak
        echo_blue "Backed up existing logid config file"
    fi
    if [ -n $DESKTOP_SESSION ]; then
        sudo ln -s ~/ubuntu-setup/etc/logid.cfg /etc/logid.cfg
    else
        sudo ln -s ~/ubuntu-setup/etc/logid_i3.cfg /etc/logid.cfg
    fi
else
    echo_blue "No change to /etc/logid.cfg"
fi

# start logid service
sudo systemctl start logid

# make it so logid service always starts on login
sudo systemctl enable logid

cd $CUR_DIR

echo_green "logiopts installed"

