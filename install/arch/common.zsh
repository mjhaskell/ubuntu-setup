#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing common packages"

sudo pacman -Syu

# create my common folder structure
if [ ! -d $HOME/software ]; then mkdir $HOME/software; fi
if [ ! -d $HOME/bin ]; then mkdir $HOME/bin; fi
if [ ! -d $HOME/tmp ]; then mkdir $HOME/tmp; fi
if [ ! -d $HOME/scratch ]; then mkdir $HOME/scratch; fi


# linux
sudo pacman -S --needed archlinux-keyring dkms
# linux linux-base linux-headers amd-microcode intel-microcode

# general utility
sudo pacman -S --needed curl wget openssh rsync unzip
sudo pacman -S --needed git lazygit
sudo pacman -S --needed bat ripgrep fd fzf eza
sudo pacman -S --needed htop bottom powertop
sudo pacman -S --needed usbutils
sudo pacman -S --needed dosfstools exfatprogs nvme-cli smartmontools
sudo pacman -S --needed man-pages man-db
sudo pacman -S --needed lshw
sudo pacman -S --needed duf  # disk utility

if [ ! -d $HOME/.config/lazygit ]; then
  ln -s $SETUP_DIR/dotfiles/config/lazygit $HOME/.config/.
fi
if [ ! -f $HOME/.ssh/config ]; then
  touch $HOME/.ssh/config
  echo "Host github" >> $HOME/.ssh/config
  echo "  Hostame github.com" >> $HOME/.ssh/config
  echo "  User <username>" >> $HOME/.ssh/config
  echo "  IdentityFile ~/.ssh/<private_key>" >> $HOME/.ssh/config
  echo "" >> $HOME/.ssh/config
fi
echo_purple "You may want to disable ssh passwd authentication in /etc/ssh/..."

# vim
sudo pacman -S --needed gvim  # gvim has system +clipboard
if [ ! -f $HOME/.vimrc ]; then
  ln -s $SETUP_DIR/dotfiles/vimrc $HOME/.vimrc

# tmux
sudo pacman -S --needed tmux
if [[ ! -f $HOME/.tmux.conf ]]; then
  ln -s $SETUP_DIR/dotfiles/apps/tmux/tmux.conf $HOME/.tmux.conf
fi

# Arch
sudo packman -S --needed paman-contrib

# fonts
sudo pacman -S --needed ttf-sourcecodepro-nerd ttf-nerd-fonts-symbols
# sudo pacman -S --needed ttf-joypixels  # moved to AUR
sudo pacman -S --needed noto-fonts-emoji

### network
sudo pacman -S --needed ifplugd ldns
sudo pacman -S --needed openresolv
# sudo pacman -S --needed systemd-resolved  # this OR openresolv

# ethernet
sudo pacman -S --needed ethtool dhcpcd
# wifi
sudo pacman -S --needed iwd


