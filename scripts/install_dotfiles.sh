#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

setup_link()
{
    SYM_FILE=$1
    SRC_FILE=$2
    SYM_DIR=${3:-$HOME}
    SRC_DIR=${4:-$SETUP_DIR/dotfiles}

    if [ ! -d $SYM_DIR ]; then
        mkdir -p $SYM_DIR
        echo_blue "Created $SYM_DIR"
    fi
    if [ ! -h $SYM_DIR/$SYM_FILE ]; then
        if [ -f $SYM_DIR/$SYM_FILE ]; then
            mv $SYM_DIR/$SYM_FILE $SYM_DIR/$SYM_FILE.bak
            echo_red "Moved $SYM_DIR/$SYM_FILE to $SYM_DIR/$SYM_FILE.bak"
        fi
        ln -s $SRC_DIR/$SRC_FILE $SYM_DIR/$SYM_FILE
        echo_blue "Linked $SYM_DIR/$SYM_FILE -> $SRC_DIR/$SRC_FILE"
    else
        echo_purple "No change to $SYM_DIR/$SYM_FILE"
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
setup_link samedir.sh termite_samedir.sh ~/bin/termite ~/ubuntu-setup/bin

# ubuntu server
setup_link .Xresources Xresources
setup_link .xinitrc xinitrc
setup_link .xserverrc xserverrc

# VS Code
setup_link settings.json vscode_settings.json ~/.config/Code/User

echo_green "Dotfiles installed"
