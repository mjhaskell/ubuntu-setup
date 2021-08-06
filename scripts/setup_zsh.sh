#!/bin/sh

echo_blue "setting up zsh"

SCRIPT_DIR="$( cd "$( dirname $0 )" && pwd )"
SETUP_DIR="$( cd $SCRIPT_DIR/.. && pwd )"

change_shell()
{
    if [ $SHELL = /bin/zsh ]; then
        echo_green "Shell is already zsh"
    else
        chsh -s /bin/zsh $USER
        export SHELL=/bin/zsh
        echo_green "switched to zsh"
        echo_purple "Log out for change to take place in new terminals"
    fi
}

if [ ! -d ~/.oh-my-zsh ]; then
    sh $SCRIPT_DIR/install_ohmyzsh.sh
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions

if [ ! -h ~/.oh-my-zsh/themes/mat.zsh-theme ]; then
    if [ -f ~/.oh-my-zsh/themes/mat.zsh-theme ] ; then
        rm ~/.oh-my-zsh/themes/mat.zsh-theme
    fi
    ln -s $SETUP_DIR/dotfiles/mat.zsh-theme ~/.oh-my-zsh/themes/mat.zsh-theme
fi

## change zsh theme to my custom theme
if ! grep -q 'ZSH_THEME="mat"' ~/.zshrc; then
    echo_blue "Changing ZSH_THEME to mat"
    sed -i 's/^ZSH_THEME=".*"$/ZSH_THEME="mat"/' ~/.zshrc
fi

## add custom plugins
if grep -q 'plugins=(git)' ~/.zshrc; then
    echo_blue "Adding zsh plugins"
    sed -i 's/^plugins=(git).*$/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting)\nautoload -U compinit \&\& compinit/' ~/.zshrc
fi

TEXT='\n# source custom termrc\nif [ -f ~/.termrc ]; then . ~/.termrc; fi\n'
if ! grep -q '~/.termrc' ~/.zshrc; then
    echo_blue "Appending termrc to zshrc"
    echo "$TEXT" >> ~/.zshrc
fi
unset TEXT

echo_blue "Changing shell to zsh"
if cat /etc/shells | grep -q /bin/zsh; then
    change_shell
else
    echo_blue "Installing zsh"
    sudo apt install -y zsh
    if cat /etc/shells | grep -q /bin/zsh; then
        change_shell
    else
        echo_red "[ERROR] can't switch to zsh\n\t/bin/zsh does not exist"
    fi
fi

# zsh ~/.zshrc
exec zsh -lc "echo_green Successfully opened zsh; zsh -i"
# exec zsh -lc "echo_green Successfully opened zsh; sh $SCRIPT_DIR/test.sh; zsh -i"
