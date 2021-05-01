#!/bin/sh

echo_blue "installing vim"

CUR_DIR="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

# install vim
sudo apt remove -y vim
sudo apt install -y vim-gtk

# install vim-plug package manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy UltiSnips folder for nvim to load custom snippets
ln -s $SETUP_DIR/UltiSnips ~/.vim/UltiSnips

# Need a Nerd Font to use some plugins
# Also might need to manually change terminal profile to use a nerd-font
cd ~/software
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh CodeNewRoman
sudo fc-cache -f -v
cd ~/software
#rm -rf nerd-fonts

# install vim pluggins
vim -c 'PlugInstall | quit | quit'


## CQuery was archived...and it did not even build (did not `#include <string>`)
#sudo apt install -y libncurses5
#git clone https://github.com/cquery-project/cquery --recursive
#cd cquery
#mkdir build && cd build
#cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/.local/ -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
#cmake --build .
#cmake --build . --target install


## I don't remember what these pip installs were for, but it seems to work
## without them and I don't want to pip install without being in a venv
# if running pip gives an error about finding "main" then see this website:
# https://stackoverflow.com/questions/28210269/importerror-cannot-import-name-main-when-running-pip-version-command-in-windo
#pip install testresources
#pip install python-language-server

cd $CUR_DIR

echo_green "vim installed"
