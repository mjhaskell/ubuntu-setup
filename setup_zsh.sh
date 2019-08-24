#!/bin/bash

echo_blue "setting up zsh"

./install_ohmyzsh.sh

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

echo_purple "Log out for change to take place"

