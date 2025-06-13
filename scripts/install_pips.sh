#!/bin/sh

echo_blue "Installing python libs"

# pygame deps
sudo apt install -y libfreetype-dev libsdl-image1.2-dev libsdl-mixer1.2-dev
sudo apt install -y libsdl1.2-dev libsdl-ttf2.0-dev libportmidi-dev
# pytesseract/tesserocr deps
sudo apt install -y libtesseract-dev libleptonica-dev tesseract-ocr

if [ -d $HOME/.pyvenvs/default ]; then
    PIP=$HOME/.pyvenvs/default/bin/pip
    echo_purple "upgrading pip"
    $PIP install --upgrade pip setuptools wheel

    echo_blue "installing python libs with pip"
    $PIP install ipython numpy scipy pygame matplotlib pybind11 vtk
    # $PIP install pyqt5 pyqtgraph pyopengl pyopengl_accelerate gnupg
    # pyqt6 or pyside6
    $PIP install pyqt6 pyqtgraph pyopengl gnupg empy
    $PIP install pyopencl pytesseract tesserocr jupyter control
    $PIP install pylint autopep8
else
    echo_red "$HOME/.pyvenvs/default does not exist"
fi

echo_green "python libs installed"
