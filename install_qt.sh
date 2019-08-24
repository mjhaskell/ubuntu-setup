#!/bin/bash

echo_blue "installing qt"

mkdir ~/software/qt_installer
cd ~/software/qt_installer
wget -O qt-installer.run http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
chmod +x qt-installer.run
echo_purple "Install version 5.10.1"
echo_purple "Use installer framework 3.0 in tools"
./qt-installer.run
cd ~/scripts
rm -rf ~/software/qt_installer

echo_green "launched qt-installer"

