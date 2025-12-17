#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing vscode"

sudo pacman -S --needed code

if [ ! -d $HOME/.config/Code/User ]; then
  mkdir -p $HOME/.config/Code/User
  ln -s $SETUP_DIR/dotfiles/apps/vscode/settings.json $HOME/.config/Code/User/.

  # wasn't sure where custom launch file should go...might be in local repo
  # ln -s $SETUP_DIR/dotfiles/apps/vscode/launch.json $HOME/.config/Code/User/.
fi

echo_green "vscode installed"
