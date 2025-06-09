#!/bin/sh

echo_blue "installing neovim"

CUR_DIR="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

FILE=nvim-linux-x86_64
SAVE_PATH=~/software/$FILE.tar.gz

# install latest neovim
curl -fLo $SAVE_PATH https://github.com/neovim/neovim/releases/latest/download/$FILE.tar.gz

if [ -d /opt/nvim ]; then
    sudo rm -rf /opt/nvim
fi

sudo tar -C /opt -xzf $SAVE_PATH

if ! grep -q 'export PATH="$PATH:/opt/nvim"' ~/.zshrc; then
    echo_blue "Adding nvim to PATH"
    echo "export PATH=\"\$PATH:/opt/$FILE/bin\"" >> ~/.zshrc
fi

echo_green "nvim installed"

