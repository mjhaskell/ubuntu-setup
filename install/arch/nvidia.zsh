#!/usr/bin/zsh

# see:
#   https://wiki.archlinux.org/title/NVIDIA
#   https://wiki.archlinux.org/title/Hardware_video_acceleration
#   https://wiki.archlinux.org/title/Vulkan

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing nvidia"

### see Arch wiki on nvidia for options
# sudo pacman -S nvidia  # TODO: decide on open vs proprietary
sudo pacman -S --needed nvidia-open
# TODO: check if using linux-lts kernel and install nvidia-open-lts if so

sudo pacman -S --needed nvidia-utils
sudo pacman -S --needed mesa-utils

# hardware video acceleration
sudo pacman -S --needed libva-nvidia-driver libva-utils

sudo pacman -S --needed vulkan-tools vulkan-extra-tools 
sudo pacman -S --needed vulkan-extra-layers vulkan-utility-libraries
sudo pacman -S --needed vulkan-headers vulkan-gfxstream
sudo pacman -S --needed vulkan-validation-layers vulkan-virtio

# installed by others
# vulkan-icd-loader

### cmds to see status
# lsmod | grep nouveau
# sudo lshw -class video
# lspci -nnk | grep -iA2 vga

echo_green "nvidia installed"
