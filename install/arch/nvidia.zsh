#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing nvidia"

### see Arch wiki on nvidia for options
# sudo pacman -S nvidia
sudo pacman -S --needed nvidia-open

sudo pacman -S --needed nvidia-utils
sudo pacman -S --needed mesa-utils

sudo pacman -S --needed vulkan-tools
sudo pacman -S --needed vulkan-extra-layers vulkan-extra-tools vulkan-utility-libraries
sudo pacman -S --needed vulkan-headers vulkan-gfxstream
sudo pacman -S --needed vulkan-validation-layers vulkan-virtio

# installed by others
# vulkan-icd-loader

### cmds to see status
# lsmod | grep nouveau
# sudo lshw -class video
# lspci -nnk | grep -iA2 vga

echo_green "nvidia installed"
