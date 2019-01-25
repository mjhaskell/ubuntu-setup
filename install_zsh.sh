#!/bin/bash

echo_blue "installing zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ln -s ~/scripts/dotfiles/zsh_aliases ~/.zsh_aliases
rm ~/.zshrc
ln -s ~/scripts/dotfiles/zshrc ~/.zshrc
ln -s ~/scripts/dotfiles/mat.zsh-theme ~/.oh-my-zsh/themes/mat.zsh-theme
source ~/.zshrc

echo_green "zsh installed"

chsh -s /bin/zsh
zsh
