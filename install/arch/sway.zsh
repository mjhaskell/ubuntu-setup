#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/../.. && pwd)"
DOTFILES_DIR="$SETUP_DIR/dotfiles"

link_dir() {
  if [ ! -d $2 ]; then
    ln -s $1 $2
    echo_blue "Linked $2 -> $1"
  else
    echo_yellow "Dir already exists: $2"
  fi
}


echo_blue "Installing sway"

# need a specific base font (if you don't install you will see a list of $HOME10 options)
sudo pacman -S --needed ttf-dejavu

# wayland
sudo pacman -S --needed wayland xorg-xwayland qt6-wayland
sudo pacman -S --needed wl-clipboard wev

# terminal
sudo pacman -S --needed foot foot-terminfo
link_dir $DOTFILES_DIR/config/foot $HOME/.config/foot
link_dir $DOTFILES_DIR/config/fontconfig $HOME/.config/fontconfig
# sudo cp $HOME/linarch/etc/fonts_local.conf /etc/fonts/local.conf

# application launcher
sudo pacman -S --needed fuzzel
link_dir $DOTFILES_DIR/config/fuzzel $HOME/.config/fuzzel

# sway
sudo pacman -S --needed sway jq
link_dir $DOTFILES_DIR/config/sway $HOME/.config/sway

# status bar
sudo pacman -S --needed i3status
link_dir $DOTFILES_DIR/config/i3status $HOME/.config/i3status

# screen lock
sudo pacman -S --needed swayidle swaylock
link_dir $DOTFILES_DIR/config/swaylock $HOME/.config/swaylock

# screen saver
sudo pacman -S --needed asciiquarium

# browser
sudo pacman -S --needed chromium
# TODO: figure out how to save and transfer profiles/extensions

# screenshots
sudo pacman -S --needed grim slurp flameshot
# link_dir $DOTFILES_DIR/config/flameshot $HOME/.config/flameshot
link_dir $DOTFILES_DIR/config/xdg-desktop-portal $HOME/.config/xdg-desktop-portal

# signal
sudo pacman -S --needed signal-desktop

# set system theme to dark
# see https://wiki.archlinux.org/title/Dark_mode_switching
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
# gsettings set org.gnome.desktop.wm.preferences theme "Adwaita-dark"

echo_green "sway installed"
