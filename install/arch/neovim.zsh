#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing neovim"

sudo pacman -S --needed neovim

sudo pacman -S --needed --asdeps tree-sitter-cli python-pynvim
sudo pacman -S --needed --asdeps fd ripgrep fzf lazygit
sudo pacman -S --needed --asdeps rustup
sudo pacman -S --needed --asdeps nodejs npm

if [ ! -d $HOME/.config/nvim ]; then
  ln -s $HOME/ubuntu-setup/dotfiles/config/nvim $HOME/.config.
fi

echo_green "neovim installed"
