#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing C++ packages"

# C++ compilers and build tools
sudo pacman -S --needed make cmake ninja ccache
sudo pacman -S --needed gcc gdb
sudo pacman -S --needed clang lld llvm lldb libc++

# C++ libraries
sudo pacman -S --needed eigen gtest

echo_green "C++ packages installed"
