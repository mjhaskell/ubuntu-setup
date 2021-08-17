#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"

sh $SCRIPT_DIR/install_common.sh
sh $SCRIPT_DIR/setup_sshkey.sh
sh $SCRIPT_DIR/setup_keybindings.sh
sh $SCRIPT_DIR/install_dotfiles.sh
sh $SCRIPT_DIR/install_vim.sh
# sh $SCRIPT_DIR/install_pips.sh
