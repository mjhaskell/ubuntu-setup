#!/bin/bash

rm ~/.bashrc
ln -s ~/scripts/dotfiles/bashrc ~/.bashrc
rm ~/.bash_aliases
ln -s ~/scripts/dotfiles/bash_aliases ~/.bash_aliases
source ~/.bashrc

rm ~/.gitconfig
ln -s ~/scripts/dotfiles/gitconfig ~/.gitconfig

rm ~/.config/nvim/init.vim
ln -s ~/scripts/dotfiles/init.vim ~/.config/nvim/init.vim

ln -s ~/scripts/dotfiles/tmux-snapshot ~/.tmux-snapshot
ln -s ~/scripts/dotfiles/tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf
