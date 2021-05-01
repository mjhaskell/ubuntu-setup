#!/bin/sh

echo_blue "intalling latex"

#sudo apt install texlive-full texmaker
sudo apt install -y texlive-latex-extra texlive-font-utils biber
sudo apt install -y texlive-bibtex-extra lmodern latexmk
sudo apt install -y texlive-luatex texlive-xetex

echo_green "latex installed"

