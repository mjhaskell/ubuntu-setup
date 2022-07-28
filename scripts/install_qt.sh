#!/bin/sh

echo_blue "installing qt"

# Last time I tried to run this (4/2020) Qt had changed to require an account
# with them. I did not create an account, but rather did
sudo apt install -y --install-recommends qtcreator
sudo apt install -y qtbase5-dev qt5-qmake qttools5-dev qttools5-dev-tools
sudo apt install -y qtwebengine5-dev libqt5svg5-dev libqt5websockets5-dev
sudo apt install -y qt5-doc qt5-doc-html qtbase5-doc-html qtbase5-examples
sudo apt install -y valgrind
# and everything seems to work fine. It installed QtCreator 4.5.8, but my final
# project from ME 570 still built an ran just fine with whatever version of Qt
# was already on the computer.

#mkdir ~/software/qt_installer
#cd ~/software/qt_installer

## Get most recent installer
#wget -O qt-installer.run http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run

## Get QtCreator 4.11.0
##wget -O qt-installer.run https://download.qt.io/official_releases/qtcreator/4.11/4.11.0/qt-creator-opensource-linux-x86_64-4.11.0.run

#chmod +x qt-installer.run
#echo_purple "Install version 5.10.1"
#echo_purple "Use installer framework 3.0 in tools"
#./qt-installer.run
#cd ~/scripts
#rm -rf ~/software/qt_installer

#ln -s $HOME/software/Qt/Tools/QtCreator/bin/qtcreator $HOME/bin/qtcreator
#ln -s $HOME/software/Qt/Tools/QtCreator/bin/qtcreator.sh $HOME/bin/qtcreator.sh

#echo_green "launched qt-installer"
