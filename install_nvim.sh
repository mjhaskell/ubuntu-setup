#!/bin/bash

echo_blue "installing neovim"

# install neovim
sudo apt-add-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim

# install vim-plug package manager
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Need to create this folder to put init.vim into
if [ ! -d "${HOME}/.config" ]; then
  mkdir ${HOME}/.config
fi
if [ ! -d "${HOME}/.config/nvim" ]; then
  mkdir ${HOME}/.config/nvim
fi

# Copy UltiSnips folder for nvim to load custom snippets
ln -s ~/scripts/UltiSnips ~/.config/nvim/UltiSnips

# Need a Nerd Font to use some plugins
# Also need to manually change terminal profile to use a nerd-font
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh CodeNewRoman
sudo fc-cache -f -v
cd ~/scripts
#rm -rf nerd-fonts
## might need to install 

git clone https://github.com/cquery-project/cquery --recursive
cd cquery
git submodule update --init --recursive
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/.local/bin/ -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
cmake --build .
cmake --build . --target install
cd ../../

# if running pip gives an error about finding "main" then see this website:
# https://stackoverflow.com/questions/28210269/importerror-cannot-import-name-main-when-running-pip-version-command-in-windo
pip install testresources --user
pip install python-language-server --user

echo_green "neovim installed"
