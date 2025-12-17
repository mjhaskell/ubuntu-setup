#!/usr/bin/zsh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"
SETUP_DIR="$(cd $SCRIPT_DIR/.. && pwd)"

echo_blue "Installing tailscale"

sudo pacman -S --needed tailscale
sudo systemctl enable --now tailscaled.service
# sudo tailscale up  # log into tailnet for first time

echo_green "Tailscale installed and service enabled"
echo_purple "use `sudo tailscale up` to log into tailnet"
