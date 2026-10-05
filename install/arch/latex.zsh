#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing LaTeX"

sudo pacman -S --needed \
    texlive-latex \
    texlive-latexextra \
    texlive-latexrecommended \
    texlive-bibtexextra \
    texlive-binextra \
    texlive-mathscience \
    texlive-luatex \
    texlive-fontsextra \
    biber

echo_green "LaTeX installed"
