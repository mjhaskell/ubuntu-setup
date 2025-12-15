echo_blue "Installing Node.js"

## see https://nodejs.org/en/download

# sud  apt install npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
source "$HOME/.nvm/nvm.sh"
## NOTE: What this script seems to do that I do manually
# - NVM_DIR="$HOME/.nvm"
# - NVM_BIN="$NVM_DIR/versions/node/v22.16.0/bin"
# - NVM_DIR="$NVM_DIR/versions/node/v22.16.0/include/node"
# - NVM_CD_FLAGS="-q"
# - PATH=$PATH:$NVM_BIN

# TODO: need to source bashrc/zshrc. nvm install script adds lines there

# Download and install Node.js:
nvm install 22
# Download and install Yarn:
corepack enable yarn
# Verify the Node.js version:
node -v # Should print "v22.16.0".
nvm current # Should print "v22.16.0".
npm -v # should print "10.9.2"
yarn -v # should print 1.22.22

echo_green "Node.js installed"

