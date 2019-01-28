#!/bin/bash

if [ -f ~/.bashrc ]; then
    rm ~/.bashrc
fi
ln -s ~/scripts/dotfiles/bashrc ~/.bashrc

if [ -f ~/.bash_aliases ]; then
    rm ~/.bash_aliases
fi
ln -s ~/scripts/dotfiles/bash_aliases ~/.bash_aliases

if [ -f ~/.sh_aliases ]; then
    rm ~/.sh_aliases
fi
ln -s ~/scripts/dotfiles/sh_aliases ~/.sh_aliases

if [ -f ~/.rosrc ]; then
    rm ~/.rosrc
fi
ln -s ~/scripts/dotfiles/rosrc ~/.rosrc

if [ -f ~/.ros_aliases ]; then
    rm ~/.ros_aliases
fi
ln -s ~/scripts/dotfiles/ros_aliases ~/.ros_aliases

source ~/.bashrc

rm ~/.gitconfig
ln -s ~/scripts/dotfiles/gitconfig ~/.gitconfig

rm ~/.config/nvim/init.vim
ln -s ~/scripts/dotfiles/init.vim ~/.config/nvim/init.vim

ln -s ~/scripts/dotfiles/tmux-snapshot ~/.tmux-snapshot
ln -s ~/scripts/dotfiles/tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf
