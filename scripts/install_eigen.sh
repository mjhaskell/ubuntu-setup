#!/bin/sh

echo_blue "installing eigen"

# Ubuntu 20.04 is on 3.3.7
sudo apt install -y libeigen3-dev

# CUR_DIR="$(pwd)"

# mkdir ~/software/eigen3
# cd ~/software/eigen3
# git clone https://gitlab.com/libeigen/eigen.git
# cd eigen
# git checkout tags/3.3.7
# mkdir build && cd build
# cmake ..
# sudo make install

## Pretty printing in VS Code
DIR=$HOME/software/eigen_printing
REPO="https://gitlab.com/libeigen/eigen/-/raw/master/debug"
if [ ! -d $DIR ]; then
  mkdir $DIR
  echo_blue "Created $DIR"
fi
wget -O $DIR/printers.py $REPO/gdb/printers.py
wget -O $DIR/eigenlldb.py $REPO/lldb/eigenlldb.py

# GDB
if [ -f $HOME/.gdbinit ]; then
  mv $HOME/.gdbinit $HOME/.gdbinit.bak
  echo_blue "Moved old gdbinit to $HOME/.gdbinit.bak"
fi
echo "python
import sys
sys.path.insert(0, '$DIR')
from printers import register_eigen_printers
register_eigen_printers(None)
end" >$HOME/.gdbinit

# LLDB
if [ -f $HOME/.lldbinit ]; then
  mv $HOME/.lldbinit $HOME/.lldbinit.bak
  echo_blue "Moved old lldbinit to $HOME/.lldbinit.bak"
fi
echo "command script import $DIR/eigenlldb.py" >$HOME/.lldbinit

# cd $CUR_DIR

echo_green "eigen installed"
