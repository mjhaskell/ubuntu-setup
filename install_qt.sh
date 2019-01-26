#!/bin/bash

echo_blue "installing qt"

wget -O qt-installer.run http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
chmod +x qt-installer.run
./qt-installer.run

echo_green "launched qt-installer"

