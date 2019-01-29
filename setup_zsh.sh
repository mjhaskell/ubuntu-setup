#!/bin/bash

echo_blue "setting up zsh"

if [ -f ~/.zsh_aliases ]; then
    rm ~/.zsh_aliases
fi
ln -s ~/scripts/dotfiles/zsh_aliases ~/.zsh_aliases

if [ -f ~/.zshrc ]; then
    rm ~/.zshrc
fi
ln -s ~/scripts/dotfiles/zshrc ~/.zshrc

if [ -f ~/.oh-my-zsh/themes/mat.zsh-theme ]; then
    rm ~/.oh-my-zsh/themes/mat.zsh-theme
fi
ln -s ~/scripts/dotfiles/mat.zsh-theme ~/.oh-my-zsh/themes/mat.zsh-theme
source ~/.zshrc

echo_green "zsh installed"

chsh -s /bin/zsh
#zsh
