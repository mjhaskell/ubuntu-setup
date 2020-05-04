#!/bin/sh

echo_blue "installing vim"

# install vim
sudo apt remove -y vim
sudo apt install -y vim-gtk

# install vim-plug package manager
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy UltiSnips folder for nvim to load custom snippets
ln -s ~/scripts/UltiSnips ~/.vim/UltiSnips

# Need a Nerd Font to use some plugins
# Also need to manually change terminal profile to use a nerd-font
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh CodeNewRoman
sudo fc-cache -f -v
cd ~/scripts
#rm -rf nerd-fonts
## might need to install 

cd ~/software
git clone https://github.com/cquery-project/cquery --recursive
cd cquery
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/.local/ -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
cmake --build .
cmake --build . --target install
cd ../../
cd ~/scripts

# if running pip gives an error about finding "main" then see this website:
# https://stackoverflow.com/questions/28210269/importerror-cannot-import-name-main-when-running-pip-version-command-in-windo
pip install testresources --user
pip install python-language-server --user

echo_green "vim installed"
