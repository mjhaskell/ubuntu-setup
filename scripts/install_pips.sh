#!/bin/sh

echo_blue "Installing python libs"

# pygame deps
sudo apt install -y libfreetype-dev libsdl-image1.2-dev libsdl-mixer1.2-dev
sudo apt install -y libsdl1.2-dev libsdl-ttf2.0-dev libportmidi-dev
# pytesseract/tesserocr deps
sudo apt install -y libtesseract-dev libleptonica-dev tesseract-ocr

if echo $PATH | grep -q .virtualenvs/default; then
    echo_purple "upgrading pip"
    pip install --upgrade pip setuptools wheel

    echo_blue "installing python libs with pip"
    pip install ipython numpy scipy pygame matplotlib pyside2 pybind11 vtk
    pip install pyqt5 pyqtgraph pyopengl pyopengl_accelerate gnupg
    pip install pyopencl pytesseract tesserocr jupyter control
    pip install pylint autopep8
else
    echo_red "PATH does not contain ~/.virtualenvs/default/bin"
    echo_red "Need to install dotfiles first and source ~/.termrc"
fi

echo_green "python libs installed"
