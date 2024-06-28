# How to Use
## Right after fresh install
You want to do a few things first and power off in between to make sure they work, otherwise you might need to reinstall Ubuntu and try again.

1. `sudo dpkg --remove-architecture i382`
1. `sudo apt update && sudo apt upgrade`
   - Check that all packages upgrade successfully, messages that some packages were held back happened to me until I removed the 32 bit architecture and then I manually ran `sudo apt install <pkg>` on all of the held packages to manually upgrade them.
1. `reboot`
1. Open Software Updater -> Additional Drivers and select the newest Nvidia driver
   - Don't choose the kernel or open versions
1. `reboot`
1. `git clone https://github.com/mjhaskell/ubuntu-setup`

## Run Setup Files
Some of the install scripts require the computer to poweroff before continuing. The install files have been organized into 3 setup files. Run them in order. The computer will automatically power off after the 1st and 2nd setup scripts. If you want to use zsh rather than bash, then after the 3rd setup script run setup_zsh.sh.

### Can run any install file individually as needed
Any of the setup files can be ran individually rather than using the setup scripts.

# Items Requiring Manual Setup
## Qt
Run install_qt.sh - this creates an executable called qt-installer.run -> run this file and follow GUI instructions. The version of Qt that I typically use is 5.10.1, because that is what I have used for a while and everything works. I might upgrade sometime. Also, use this install location for aliases to work: ~/software/Qt
## Neovim
After installing neovim, run :PlugInstall\
Also need to change terminal profile to use the Code New Roman font (downloaded with install_nvim)\
If an error occured with a pip install saying it couldn't find main, then see [this website](https://stackoverflow.com/questions/28210269/importerror-cannot-import-name-main-when-running-pip-version-command-in-windo).
After fixing the pip file, you will need to run these 2 lines again (if they didn't work)\
pip install testresources --user\
pip install python-language-server --user
### Setting terminal font to a NerdFont
For the symbols to show up correctly in Neovim's NerdTree plugin, the terminal needs to be set to use a NerdFont. I have had troubles getting the downloaded NerdFont to show up in the list of available fonts for terminal profiles. See [here](https://superuser.com/questions/1335155/patched-fonts-not-showing-up-on-gnome-terminal) and [here](https://askubuntu.com/questions/1046871/nerd-font-not-fond-in-terminal-profile/) for references on how to get around this issue. I have tried installing dconf-editor and manually setting the font, and that seemed to work.
