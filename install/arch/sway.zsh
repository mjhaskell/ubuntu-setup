#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing sway"

# need a specific base font (if you don't install you will see a list of $HOME10 options)
sudo pacman -S --needed ttf-dejavu

# wayland
sudo pacman -S --needed wayland xorg-xwayland qt6-wayland
sudo pacman -S --needed wl-clipboard wev

# terminal
sudo pacman -S --needed foot foot-terminfo
if [ ! -d $HOME/.config/foot ]; then
  ln -s $SETUP_DIR/dotfiles/config/foot $HOME/.config/.
fi
if [ ! -d $HOME/.config/fontconfig ]; then
  ln -s $SETUP_DIR/dotfiles/config/fontconfig $HOME/.config/.
fi
# sudo cp $HOME/linarch/etc/fonts_local.conf /etc/fonts/local.conf

# application launcher
sudo pacman -S --needed fuzzel
if [ ! -d $HOME/.config/fuzzel ]; then
  ln -s $SETUP_DIR/dotfiles/config/fuzzel $HOME/.config/.
fi

# sway
sudo pacman -S --needed sway
if [ ! -d $HOME/.config/sway ]; then
  ln -s $SETUP_DIR/dotfiles/config/sway $HOME/.config/.
fi

# status bar
sudo pacman -S --needed i3status
if [ ! -d $HOME/.config/i3status ]; then
  mkdir $HOME/.config/i3status
  if hostnamectl | grep "Chassis" | grep -qi "laptop"; then
    ln -s $SETUP_DIR/dotfiles/config/i3status/config_laptop $HOME/.config/.
  else
    ln -s $SETUP_DIR/dotfiles/config/i3status/config_desktop $HOME/.config/.
  fi
fi

# screen lock
sudo pacman -S --needed swayidle swaylock
if [ ! -d $HOME/.config/swaylock ]; then
  ln -s $SETUP_DIR/dotfiles/config/swaylock $HOME/.config/.
fi

# screen saver
sudo pacman -S --needed asciiquarium

# browser
sudo pacman -S --needed chromium
# TODO: figure out how to save and transfer profiles/extensions

# screenshots
sudo pacman -S --needed grim slurp flameshot
if [ ! -d $HOME/.config/flameshot ]; then
  ln -s $SETUP_DIR/dotfiles/config/flameshot $HOME/.config/.
fi
if [ ! -d $HOME/.config/xdg-desktop-portal ]; then
  ln -s $SETUP_DIR/dotfiles/config/xdg-desktop-portal $HOME/.config/.
fi

# signal
sudo pacman -S --needed signal-desktop

# set system theme to dark
# see https://wiki.archlinux.org/title/Dark_mode_switching
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
# gsettings set org.gnome.desktop.wm.preferences theme "Adwaita-dark"

echo_green "sway installed"
