#!/bin/sh

echo_blue "installing openscenegraph"

sudo add-apt-repository -y ppa:openmw/openmw
sudo apt update
sudo apt install -y openscenegraph-3.4 libopenscenegraph-3.4-dev

echo_green "openscenegraph installed"
