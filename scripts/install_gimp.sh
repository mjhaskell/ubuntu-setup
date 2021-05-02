#!/bin/sh

echo_blue "installing gimp"

sudo add-apt-repository ppa:otto-kesselgulasch/gimp
sudo apt update
sudo apt install -y gimp

echo_green "gimp installed"
