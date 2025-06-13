#!/bin/sh

echo_blue "intalling lazygit"

CUR_DIR="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

mkdir ~/software/lazygit
cd ~/software/lazygit

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

cd $CUR_DIR

echo_green "lazygit installed"
