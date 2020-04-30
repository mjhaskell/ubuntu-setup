#!/bin/sh

# Last time I tried to run this (4/2020) Qt had changed to require an account
# with them. I did not create an account, but rather did
# sudo apt install qtcreator
# and everything seems to work fine. It installed QtCreator 4.5.8, but my final
# project from ME 570 still built an ran just fine with whatever version of Qt 
# was already on the computer.

echo_blue "installing qt"

mkdir ~/software/qt_installer
cd ~/software/qt_installer

# Get most recent installer
wget -O qt-installer.run http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run

# Get QtCreator 4.11.0
#wget -O qt-installer.run https://download.qt.io/official_releases/qtcreator/4.11/4.11.0/qt-creator-opensource-linux-x86_64-4.11.0.run

chmod +x qt-installer.run
echo_purple "Install version 5.10.1"
echo_purple "Use installer framework 3.0 in tools"
./qt-installer.run
cd ~/scripts
rm -rf ~/software/qt_installer

echo_green "launched qt-installer"

