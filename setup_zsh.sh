#!/bin/bash

echo_blue "setting up zsh"

if [ ! -d ~/.oh-my-zsh ]; then
    ./install_ohmyzsh.sh
fi

if [ ! -h ~/.oh-my-zsh/themes/mat.zsh-theme ]; then
    if [ -f ~/.oh-my-zsh/themes/mat.zsh-theme ] ; then 
        rm ~/.oh-my-zsh/themes/mat.zsh-theme
    fi
    ln -s ~/scripts/dotfiles/mat.zsh-theme ~/.oh-my-zsh/themes/mat.zsh-theme
fi

text=$'\n# source custom termrc\nif [ -f ~/.termrc ]; then . ~/.termrc; fi\n'
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

source ~/.zshrc

if [ "$SHELL" = "/bin/zsh" ]; then 
    echo_blue "Shell is already zsh"
    return
fi

cat /etc/shells | grep /bin/zsh > test_shells.txt
filename='test_shells.txt'
exists=0
while read line; do
    if [ "$line" = "/bin/zsh" ]; then
        exists=1
        break
    fi
done < $filename

if [ $exists = 1 ]; then
    echo_green "switched to zsh"
    chsh -s /bin/zsh $USER
else
    echo_red "[ERROR] can't switch to zsh\n\t/bin/zsh does not exist"
fi
rm test_shells.txt

source ~/.zsh_rc

echo_purple "Log out for change to take place"

