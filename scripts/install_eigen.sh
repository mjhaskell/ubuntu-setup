#!/bin/sh

echo_blue "installing eigen tag 3.3.7"

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


# Pretty printing in VS Code
if [ ! -d $HOME/software/eigen-gdb ] then
    mkdir $HOME/software/eigen-gdb
    wget -O $HOME/software/eigen-gdb/printers.py https://gitlab.com/libeigen/eigen/-/blob/master/debug/gdb/printers.py
fi

if [ ! -f $HOME/.gdbinit ] then
    echo "python
    import sys
    sys.path.insert(0, '$HOME/software/eigen-gdb')
    from printers import register_eigen_printers
    register_eigen_printers(None)
    end" > $HOME/.gdbinit
fi

# cd $CUR_DIR

echo_green "eigen installed"
