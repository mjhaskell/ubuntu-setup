#!/bin/sh

echo_blue "pip installing python libs"

pip2 install ipython numpy scipy pygame matplotlib pyside2 pybind11 --user
pip2 install pyopencl pytesseract tesserocr jupyter --user

pip3 install ipython numpy scipy pygame matplotlib pyside2 pybind11 vtk --user
pip3 install pyqt5 pyqtgraph pyopengl pyopengl_accelerate gnupg --user
pip3 install pyopencl pytesseract tesserocr jupyter control --user
pip3 install pylint autopep8 --user

echo_green "python libs installed"
