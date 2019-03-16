#!/bin/bash

echo_blue "installing lyx"

sudo add-apt-repository ppa:lyx-devel/release
sudo apt update
sudo apt install lyx

echo_green "lyx installed"
