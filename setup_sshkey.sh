#!/bin/bash

echo_blue "Setting up ssh key"

if [ -d ~/.ssh/ ]; then
    if [ -f ~/.ssh/id_rsa ]; then
        echo_blue "Found an ssh key"
    else
        echo_red ".ssh dir exists with no key"
    fi
else
    echo_red "No ssh keys exist"
    echo_blue "Generating an ssh key"
    ssh-keygen -t rsa -b 4096 -C "mhaskell9@gmail.com"
fi

echo_blue "Adding ssh key to ssh agent"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub

echo_green "ssh key has been copied to clipboard"
echo_green "Go add key to github and bitbucket"
