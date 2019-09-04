#!/bin/bash

# universal terminal rc
if [ ! -h ~/.termrc ]; then
    if [ -f ~/.termrc ]; then rm ~/.termrc; fi
    ln -s ~/scripts/dotfiles/termrc ~/.termrc
fi

# source termrc in both bashrc and zshrc
text=$'\n# source custom termrc\nif [ -f ~/.termrc ]; then . ~/.termrc; fi\n'
if ! grep -q '~/.termrc' ~/.bashrc; then
    echo_blue "Appending termrc to bashrc"
    echo "$text" >> ~/.bashrc
fi

if ! grep -q '~/.termrc' ~/.zshrc; then
    echo_blue "Appending termrc to zshrc"
    echo "$text" >> ~/.zshrc
fi
unset text

# change zsh theme to my custom theme
if ! grep -q 'ZSH_THEME="mat"' ~/.zshrc; then 
    echo_blue "Changing ZSH_THEME to mat"
    sed -i 's/^ZSH_THEME=".*"$/ZSH_THEME="mat"/' ~/.zshrc
fi

# aliases
if [ ! -h ~/.sh_aliases ]; then
    if [ -f ~/.sh_aliases ]; then rm ~/.sh_aliases; fi
    ln -s ~/scripts/dotfiles/sh_aliases ~/.sh_aliases
fi

# ROS
if [ ! -h ~/.rosrc ]; then
    if [ -f ~/.rosrc ]; then rm ~/.rosrc; fi
    ln -s ~/scripts/dotfiles/rosrc ~/.rosrc
fi

if [ ! -h ~/.ros_aliases ]; then
    if [ -f ~/.ros_aliases ]; then rm ~/.ros_aliases; fi
    ln -s ~/scripts/dotfiles/ros_aliases ~/.ros_aliases
fi

# apply changes to current shell
if [ $BASH ]; then
    echo_purple "Sourcing bashrc"
    source ~/.bashrc
elif [ $ZSH_NAME ]; then
    echo_purple "Sourcing zshrc"
    source ~/.zshrc
fi

# git
if [ ! -h ~/.gitconfig ]; then
    if [ -f ~/.gitconfig ]; then rm ~/.gitconfig; fi
    ln -s ~/scripts/dotfiles/gitconfig ~/.gitconfig
fi

# nvim
if [ ! -h ~/.config/nvim/init.vim ]; then
    if [ -f ~/.config/nvim/init.vim ]; then rm ~/.config/nvim/init.vim; fi
    ln -s ~/scripts/dotfiles/init.vim ~/.config/nvim/init.vim
fi

# tmux
if [ ! -h ~/.tmux-snapshot ]; then
    if [ -f ~/.tmux-snapshot ]; then rm ~/.tmux-snapshot; fi
    ln -s ~/scripts/dotfiles/tmux-snapshot ~/.tmux-snapshot
fi

if [ ! -h ~/.tmux.conf ]; then
    if [ -f ~/.tmux.conf ]; then rm ~/.tmux.conf; fi
    ln -s ~/scripts/dotfiles/tmux.conf ~/.tmux.conf
fi
tmux source-file ~/.tmux.conf
