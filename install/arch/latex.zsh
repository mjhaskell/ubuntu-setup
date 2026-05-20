#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing LaTeX"

sudo pacman -S --needed \
    texlive-latex \
    texlive-latexextra \
    texlive-latexrecommended \
    texlive-binextra \
    texlive-mathscience \
    texlive-luatex \
    biber

echo_green "LaTeX installed"
