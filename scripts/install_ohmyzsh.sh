#!/bin/sh

echo_blue "Configuring zsh with oh-my-zsh"
echo_purple "This will open new zsh shell - exit after it opens"

REPO=https://raw.githubusercontent.com/robbyrussell/oh-my-zsh
FILE=tools/install.sh
sh -c "RUNZSH=no $(curl -fsSL $REPO/master/$FILE)"
