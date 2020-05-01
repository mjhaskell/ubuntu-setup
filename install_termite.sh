#!/bin/sh

echo_blue "Installing termite"

sudo apt update
sudo apt install -y g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool 
sudo apt install -y libpcre2-dev libglib3.0-cil-dev libgnutls28-dev 
sudo apt install -y libgirepository1.0-dev libxml2-utils gperf

cd ~/software
git clone https://github.com/thestinger/vte-ng.git
echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd vte-ng
./autogen.sh
make && sudo make install

cd ~/software
git clone --recursive https://github.com/thestinger/termite.git
cd termite
make
sudo make install
sudo ldconfig
sudo mkdir -p /lib/terminfo/x
sudo ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60

if [ -f /usr/local/bin/termite ]; then
    mkdir -p ~/.config/termite
    cp /etc/xdg/termite/config ~/.config/termite/config
    echo_green "Termite installed"
else
    echo_red "Installation unsuccessful"
fi

cd ~/scripts

