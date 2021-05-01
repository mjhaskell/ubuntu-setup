#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

sh $SCRIPT_DIR/install_common.sh
sh $SCRIPT_DIR/setup_sshkey.sh
sh $SCRIPT_DIR/setup_keybindings.sh
sh $SCRIPT_DIR/install_dotfiles.sh
sh $SCRIPT_DIR/install_vim.sh
sh $SCRIPT_DIR/upgrade_pips.sh

#bash install_latex.sh
#bash install_eigen.sh
#bash install_OSG.sh
#bash install_gimp.sh
#bash install_lyx.sh
