#!/bin/sh

if [ ! -f /usr/bin/ssh ]; then
    echo_blue "Installing ssh"
    sudo apt install -y ssh
    echo_green "ssh installed"
fi

echo_blue "Setting up ssh key"

if [ -f ~/.ssh/id_ed25519 ]; then
    echo_blue "Found an existing ed25519 ssh key"
else
    if [ -f ~/.ssh/id_rsa ]; then
	echo_blue "Old rsa key type exists (Recommended to use ed25519)"
    fi
    echo_blue "Creating new ed25519 ssh key"
    echo "Enter git email (can leave empty): \c"
    read EMAIL
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "$EMAIL"
    echo_blue "Adding ssh key to ssh agent"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo_green "ssh key created and added to ssh agent"
fi

if [ -f /usr/bin/xclip ]; then
    xclip -sel clip < ~/.ssh/id_ed25519.pub
    echo_blue "ssh key has been copied to clipboard"
    echo_purple "Go add key to github and bitbucket"
fi

