#!/bin/sh

echo_blue "installing Zotero"

CUR_DIR="$(pwd)"

# Instructions found at: https://www.zotero.org/support/installation

PKG="Zotero_linux-x86_64"

# Download the latest Zotero tarball
# https://download.zotero.org/client/release/latest/linux-x86_64/zotero.tar.bz2
wget -O ~/software/$PKG.tar.bz2 "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64"

# Extract the tarball to /opt
if [ -d /opt/zotero ]; then
    sudo rm -rf /opt/zotero
fi
sudo tar -C /opt -xjf ~/software/$PKG.tar.bz2
sudo mv /opt/$PKG /opt/zotero

# Run the set_launcher_icon script
cd /opt/zotero
source /opt/zotero/set_launcher_icon

# Create a symbolic link to the zotero.desktop file
ln -s /opt/zotero/zotero.desktop ~/.local/share/applications/.

# Note for updates:
# You may need to re-run set_launcher_icon after certain Zotero updates.
# If something isn't working, it may help to remove the current symlink
# (~/.local/share/applications/zotero.desktop), wait a few seconds for Zotero to
# disappear from the launcher, and recreate it.

echo_purple "You may also want to install the Zotero Connector for your browser:"
echo_purple "https://www.zotero.org/download/connectors"

echo_green "Zotero installed"
