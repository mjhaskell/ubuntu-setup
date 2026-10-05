#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/../.. && pwd)"

echo_blue "Installing python"

sudo pacman -S --needed python

if [ ! -d $HOME/.pyvenvs ]; then
  mkdir $HOME/.pyvenvs
  echo_blue "Created $HOME/.pyvenvs"
fi
if [ ! -d $HOME/.pyvenvs/default ]; then
  python -m venv $HOME/.pyvenvs/default
  echo_blue "Created venv: default"
fi

source $HOME/.pyvenvs/default/bin/activate

pip install --upgrade pip
pip install --upgrade numpy ipython ipykernel
pip install --upgrade black debugpy
pip install --upgrade matplotlib pyside6 abracatabra pyopengl pyqtgraph
pip install --upgrade control sympy scipy

if [ ! -d $HOME/.ipython/profile_default/startup ]; then
  # start ipython to create config folder
  ipython -c exit
  ln -s $SETUP_DIR/dotfiles/apps/ipython/00_imports.py $HOME/.ipython/profile_default/startup/.
  echo_blue "Linked $HOME/.ipython/profile_default/startup/00_imports.py -> $SETUP_DIR/dotfiles/apps/ipython/00_imports.py"
fi

echo_green "python installed"
