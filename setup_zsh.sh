#!/bin/sh

echo_blue "setting up zsh"

if [ ! -d ~/.oh-my-zsh ]; then
    source install_ohmyzsh.sh
fi

if [ ! -h ~/.oh-my-zsh/themes/mat.zsh-theme ]; then
    if [ -f ~/.oh-my-zsh/themes/mat.zsh-theme ] ; then 
        rm ~/.oh-my-zsh/themes/mat.zsh-theme
    fi
    ln -s ~/scripts/dotfiles/mat.zsh-theme ~/.oh-my-zsh/themes/mat.zsh-theme
fi

## change zsh theme to my custom theme
if ! grep -q 'ZSH_THEME="mat"' ~/.zshrc; then
    echo_blue "Changing ZSH_THEME to mat"
    sed -i 's/^ZSH_THEME=".*"$/ZSH_THEME="mat"/' ~/.zshrc
fi

## add custom plugins
if grep -q 'plugins=(git)' ~/.zshrc; then
    echo_blue "Adding zsh plugins"
    sed -i 's/^plugins=(git).*$/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting)\nautoload -U compinit \&\& compinit/' ~/.zshrc
fi

TEXT='\n# source custom termrc\nif [ -f ~/.termrc ]; then . ~/.termrc; fi\n'
if ! grep -q '~/.termrc' ~/.zshrc; then
    echo_blue "Appending termrc to zshrc"
    echo "$TEXT" >> ~/.zshrc
fi
unset TEXT

if cat /etc/shells | grep -q /bin/zsh; then
    if [ $SHELL = /bin/zsh ]; then
        echo_green "Shell is already zsh"
    else
        chsh -s /bin/zsh $USER
        echo_green "switched to zsh"
        echo_purple "Log out for change to take place"
    fi
else
    echo_blue "Installing zsh"
    sudo apt install -y zsh
    if cat /etc/shells | grep -q /bin/zsh; then
        if [ $SHELL = /bin/zsh ]; then
            echo_green "Shell is already zsh"
        else
            chsh -s /bin/zsh $USER
            echo_green "switched to zsh"
            echo_purple "Log out for change to take place"
        fi
    else
        echo_red "[ERROR] can't switch to zsh\n\t/bin/zsh does not exist"
    fi
fi

zsh ~/.zshrc

