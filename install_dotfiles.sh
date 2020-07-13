#!/bin/sh

setup_link()
{
    symfile=$1
    srcfile=$2
    symdir=${3:-~}
    srcdir=${4:-~/scripts/dotfiles}

    if [ ! -d $symdir ]; then 
        mkdir -p $symdir
        echo_blue "Created $symdir"
    fi
    if [ ! -h $symdir/$symfile ]; then
        if [ -f $symdir/$symfile ]; then 
            mv $symdir/$symfile $symdir/$symfile.bak
            echo_red "Moved $symdir/$symfile to $symdir/$symfile.bak"
        fi
        ln -s $srcdir/$srcfile $symdir/$symfile
        echo_blue "Linked $symdir/$symfile -> $srcdir/$srcfile"
    else
        echo_purple "No change to $symdir/$symfile"
    fi
}

echo_blue "Installing dotfiles"

# universal terminal rc
setup_link .termrc termrc

# source termrc in both bashrc and zshrc
TEXT='\n# source custom termrc\nif [ -f ~/.termrc ]; then . ~/.termrc; fi\n'
if ! grep -q '~/.termrc' ~/.bashrc; then
    echo "$TEXT" >> ~/.bashrc
    echo_blue "Appended termrc to bashrc"
fi

if [ -f ~/.zshrc ]; then
    if ! grep -q '~/.termrc' ~/.zshrc; then
        echo "$TEXT" >> ~/.zshrc
        echo_blue "Appended termrc to zshrc"
    fi
    
    # change zsh theme to my custom theme
    if ! grep -q 'ZSH_THEME="mat"' ~/.zshrc; then 
        sed -i 's/^ZSH_THEME=".*"$/ZSH_THEME="mat"/' ~/.zshrc
        echo_blue "Changed ZSH_THEME to mat"
    fi
fi
unset TEXT

# aliases
setup_link .sh_aliases sh_aliases

# ROS
setup_link .rosrc rosrc
setup_link .ros_aliases ros_aliases 

# apply changes to current shell
if [ $BASH ]; then
    echo_purple "Sourcing bashrc"
    source ~/.bashrc
elif [ $ZSH_NAME ]; then
    echo_purple "Sourcing zshrc"
    source ~/.zshrc
fi

# git
setup_link .gitconfig gitconfig

# vim
setup_link .vimrc vimrc

# tmux
setup_link .tmux-snapshot tmux-snapshot
setup_link .tmux.conf tmux.conf
tmux source-file ~/.tmux.conf

# ipython
setup_link 00_imports.py 00_imports.py ~/.ipython/profile_default/startup

# i3
setup_link config i3_config ~/.config/i3

# i3status
setup_link config i3status_config ~/.config/i3status

# termite
setup_link config termite_config ~/.config/termite
setup_link config_day termite_config_day ~/.config/termite
setup_link samedir.sh termite_samedir.sh ~/bin/termite

# ubuntu server
setup_link .Xauthority Xauthority
setup_link .Xresources Xresources 
setup_link .xinitrc xinitrc 
setup_link .xserverrc xserverrc 

# VS Code
setup_link settings.json vscode_settings.json ~/.config/Code/User

echo_green "Dotfiles installed"

