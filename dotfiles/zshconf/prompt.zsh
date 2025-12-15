autoload -Uz promptinit
promptinit

setopt prompt_subst

###### SYNTAX
# see https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
# for more options
#
# %F{color}     - start using foreground <color>
# %f            - end changing foreground color
# %K{color}     - start using background <color>
# %k            - end changing background color
# %B            - start using bold
# %b            - end using bold
# %E            - clear to end of line
# %U            - start underline mode
# %u            - end underline mode
#
# %~            - CWD (current working directory)
# %n            - USERNAME
# %m            - HOSTNAME up to first '.' (can add an int after % to specify how many characters and it can be negative
# to go from the end)
# %M            - full HOSTNAME
#
# custom colors
# typeset -H my_grey="%F{237}"
######

## could also try to use exported info from git (vcs_info)
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh

git_prompt_info() {
  local GIT_PROMPT_PREFIX="%F{yellow}"
  local GIT_PROMPT_SUFFIX="%f"
  local GIT_PROMPT_DIRTY=" %F{red}"
  local GIT_PROMPT_CLEAN=""

  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    local GIT_BRANCH="($(git symbolic-ref --short HEAD))"
    if [ -z "$(git status --porcelain)" ]; then
      echo "$GIT_PROMPT_PREFIX$GIT_BRANCH$GIT_PROMPT_CLEAN$GIT_PROMPT_SUFFIX"
    else
      echo "$GIT_PROMPT_PREFIX$GIT_BRANCH$GIT_PROMPT_DIRTY$GIT_PROMPT_SUFFIX"
    fi
  else
    echo ""
  fi
}

# case $TERM in
#   termite|foot*|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
#     function precmd () {
#       print -Pn "\e]0; %# @%m:%~\a"
#     }
#     function preexec () { print -Pn "\e]0; %# @%m:%~ %(!.#.») $1\a" }
#     ;;
#   screen|screen-256color)
#     function precmd () {
#       print -Pn "\e]83;title \"$1\"\a"
#       print -Pn "\e]0;$TERM - (%L) %# @%m:%~\a"
#       git_prompt_info
#     }
#     function preexec () {
#       print -Pn "\e]83;title \"$1\"\a"
#       print -Pn "\e]0;$TERM - (%L) %# @%m:%~ ($1)\a"
#     }
#     ;;
# esac


prompt_custom_theme_setup() {
  # local return_code="%B%(?.%F{green}%f.%F{red}%? ↵%b%f)"
  local return_code="%B%(?..%F{red}%? ↵%b%f)"

  if [[ $UID -eq 0 ]]; then # for root
      local user="%B%F{red}%n%b%f"
      local symbol="%B%F{red}#%b%f"
  else
      local user="%B%F{green}%n%b%f"
      local symbol="%B%F{cyan}>%b%f"
  fi

  if [ "$SSH_TTY" ]; then # change prompt when in ssh
      # 󱥠 󰿆 󱦚 󱥡 󰉑 󱪧 󱦛
      #local host="@%F{magenta}%m%F{yellow}󱥠%f:" #(ssh)
      local host="%F{magenta}%m%f" #(ssh)
      local symbol="%B%F{cyan} %b%f"
      local user="%B%F{green}DBA %n%b%f"
  else
      local host=''
  fi

  if [[ "${VIRTUAL_ENV_PROMPT[1]}" == "(" ]]; then
    local venv="${VIRTUAL_ENV_PROMPT}"
  else
    local venv="(${VIRTUAL_ENV_PROMPT}) "
  fi
  # local venv="${VIRTUAL_ENV_PROMPT}"
  local cwd="%B%F{cyan}%~%b%f"
  local git_info="$(git_prompt_info)"

  local line1="${venv}${user}: ${cwd} ${git_info}"
  local line2="${host}${symbol} " 
  local newline=$'\n'

  PROMPT="${line1}${newline}${line2}"
  RPS1="${return_code}"
}

## can use precmd, but might be better to append to list of precmds
#precmd() {
#  prompt_custom_theme_setup
#}

precmd_functions+=(prompt_custom_theme_setup)

## can also use zsh hook to add to list of precmds
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd prompt_custom_theme_setup
