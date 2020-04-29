#!/bin/sh

echo_blue "upgrading pip2"
pip2 install --upgrade pip setuptools wheel --user
echo_green "pip2 upgraded"

echo_blue "upgrading pip3"
pip3 install --upgrade pip setuptools wheel --user
echo_green "pip3 upgraded"

echo_red "computer will now power off"
reboot
