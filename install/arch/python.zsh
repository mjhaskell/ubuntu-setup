#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing python"

sudo pacman -S --needed python

if [ ! -d $HOME/.pyvenvs ]; then
  mkdir $HOME/.pyvenvs
fi
if [ ! -d $HOME/.pyvenvs/default ]; then
  python -m venv $HOME/.pyvenvs/default
fi

source $HOME/.pyvenvs/default/bin/activate

pip install --upgrade pip
pip install --upgrade numpy sympy ipython ipykernel
pip install --upgrade black debugpy
pip install --upgrade matplotlib pyside6 abracatabra pyopengl pyqtgraph
pip install --upgrade control

if [ ! -d $HOME/.ipython/profile_default/startup ]; then
  ln -s $SETUP_DIR/dotfiles/apps/ipython/00_imports.py $HOME/.ipython/profile_default/startup/.
fi

echo_green "python installed"
