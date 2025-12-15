#!/bin/sh

echo_blue "intalling LaTeX"

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SETUP_DIR/.. && pwd )"

echo "setup dir: $SETUP_DIR"
echo "script dir: $SCRIPT_DIR"

# base LaTeX installation
# sudo apt install -y texlive-full  ## full installation, but ~6GB
sudo apt install -y texlive
sudo apt install -y texlive-latex-extra texlive-font-utils
# sudo apt install -y biber
# sudo apt install -y texlive-bibtex-extra lmodern
# sudo apt install -y texlive-luatex texlive-xetex
sudo apt intall -y latexmk
sudo apt install -y texlive-science  # may come with texlive-latex-extra

# PDF viewer
sudo apt install -y zathura

# LaTeX editor
# sudo apt install -y texstudio
# sudo apt install -y texmaker 

# Reference manager
# sudo apt install -y jabref
# sh $SCRIPT_DIR/install_zotero.sh

echo_green "LaTeX installed"

