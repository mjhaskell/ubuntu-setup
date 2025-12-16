## Ubuntu
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# fpath=($fpath $HOME/software/zsh-completions/src)

# autoload -Uz compinit # not sure if this is needed
# compinit
# rm -f ~/.zcompdump; compinit

## Arch
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

## All
# zsh_syntax_highlighter customization
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp)

# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES

# # To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
#
## To have paths colored instead of underlined
## ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
## ZSH_HIGHLIGHT_STYLES[path]='fg=#0093ad'
## ZSH_HIGHLIGHT_STYLES[path]='fg=31'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
#
## # To disable highlighting of globbing expressions
## ZSH_HIGHLIGHT_STYLES[globbing]='none'

