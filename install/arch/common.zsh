#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/../.. && pwd)"
DOTFILES_DIR="$SETUP_DIR/dotfiles"

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
sudo pacman -S --needed zsh zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting zsh-completions
sudo pacman -S --needed git lazygit git-delta
sudo pacman -S --needed bat ripgrep fd fzf eza
sudo pacman -S --needed htop bottom powertop
sudo pacman -S --needed usbutils
sudo pacman -S --needed dosfstools exfatprogs nvme-cli smartmontools
sudo pacman -S --needed man-pages man-db
sudo pacman -S --needed lshw
sudo pacman -S --needed duf  # disk utility

link_file() {
  if [ ! -f $2 ]; then
    ln -s $1 $2
    echo_blue "Linked $2 -> $1"
  else
    echo_yellow "File already exists: $2"
  fi
}
link_dir() {
  if [ ! -d $2 ]; then
    ln -s $1 $2
    echo_blue "Linked $2 -> $1"
  else
    echo_yellow "Dir already exists: $2"
  fi
}

link_file $DOTFILES_DIR/zshrc $HOME/.zshrc
link_dir $DOTFILES_DIR/zshconf $HOME/.zshconf
link_file $DOTFILES_DIR/zshenv $HOME/.zshenv
link_file $DOTFILES_DIR/termrc $HOME/.termrc
link_file $DOTFILES_DIR/sh_aliases $HOME/.sh_aliases
link_file $DOTFILES_DIR/gitconfig $HOME/.gitconfig
link_file $DOTFILES_DIR/apps/tmux/tmux.conf $HOME/.tmux.conf
link_dir $DOTFILES_DIR/config/lazygit $HOME/.config/lazygit
link_file $SETUP_DIR/bin/create_sshkey $HOME/bin/create_sshkey

if [ ! -f $HOME/.ssh/config ]; then
  touch $HOME/.ssh/config
  echo "Host github" >> $HOME/.ssh/config
  echo "  Hostame github.com" >> $HOME/.ssh/config
  echo "  User git" >> $HOME/.ssh/config
  echo "  IdentityFile ~/.ssh/git.github" >> $HOME/.ssh/config
  echo "" >> $HOME/.ssh/config
fi
echo_purple "You may want to disable ssh passwd authentication in /etc/ssh/..."

# vim
sudo pacman -S --needed gvim  # gvim has system +clipboard
link_file $DOTFILES_DIR/vimrc $HOME/.vimrc

# tmux
sudo pacman -S --needed tmux
link_file $DOTFILES_DIR/apps/tmux/tmux.conf $HOME/.tmux.conf

# Arch
sudo pacman -S --needed pacman-contrib

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


echo_green "Common packages installed"

