# How to Use
## Clone Repo Into Home (~)
git clone https://github.com/mhask94/scripts

## Run setup_all to Install All from Scratch
cd scripts/\
./setup_all

### Can run any install file as needed
### Can run setup_dotfiles alone

# Items Requiring Manual Setup
## Qt
Follow the instructions in install_Qt.txt
## Neovim
After installing neovim, run :PlugInstall\
Also need to change terminal profile to use Hack font (downloaded with install_nvim)\
If an error occured with a pip install saying it couldn't find main, then see this website:\
https://stackoverflow.com/questions/28210269/importerror-cannot-import-name-main-when-running-pip-version-command-in-windo \
After fixing the pip file, you will need to run these 2 lines again (if they didn't work)\
pip install testresources --user\
pip install python-language-server --user
