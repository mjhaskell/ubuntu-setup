autoload -Uz promptinit
promptinit

setopt prompt_subst


###### SYNTAX
## see https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
## for more options
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
# %#            - prompt symbol (defaults = root: #, user: %)
# %n            - USERNAME
# %m            - HOSTNAME up to first '.' (can add an int after % to specify how many characters and it can be negative
# to go from the end)
# %M            - full HOSTNAME
#
## custom colors
# typeset -H my_grey="%F{237}"
#
## ternary expressions
# %(!.true.false)  # test if root user
# %(?.true.false)  # test if error from prev command
######

## could also try to use exported info from git (vcs_info)
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh


################# Setting Window Titles ########################################
# https://unix.stackexchange.com/a/10533
# https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html#SEC52
# section 13.3 --> conditional substrings in prompts
# https://zsh.sourceforge.io/Doc/Release/Functions.html
# section 9.3 --> preexec
display_path() {
  if [ "$SSH_TTY" ]; then # change prompt when in ssh
    print -Pn "@%m:%~ %(!.#.)"
  else
    print -Pn "%~ %(!.#.»)"
  fi
}
set_window_title() {
  if [ $# -eq 2 ]; then  # $1 should be term cmd
    printf "%b%s %s%b" "\e]0;" "$1" "$2" "\007"
  else
    printf "%b%s%b" "\e]0;" "$1" "\a"
  fi
}

case $TERM in
  termite|foot*|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    function precmd () {
     set_window_title "$(display_path)"
    }
    function preexec () {
      local cmd=$1
      set_window_title "$(display_path)" "$cmd"
    }
    ;;
  # screen|screen-256color)
  #   function precmd () {
  #     print -Pn "\e]83;title \"$1\"\a"
  #     print -Pn "\e]0;$TERM - (%L) %# @%m:%~\a"
  #     git_prompt_info
  #   }
  #   function preexec () {
  #     print -Pn "\e]83;title \"$1\"\a"
  #     print -Pn "\e]0;$TERM - (%L) %# @%m:%~ ($1)\a"
  #   }
  #   ;;
esac
################# Setting Window Titles ########################################


################# Setting Zsh Prompt ###########################################
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

prompt_venv() {
  [[ -n "$VIRTUAL_ENV" ]] && print -n "(${VIRTUAL_ENV:t}) " || print -n ""
}

prompt_custom_theme_setup() {
  # local return_code="%B%(?.%F{green}%f.%F{red}%? ↵%b%f)"
  local return_code="%B%(?..%F{red}%? ↵%b%f)"

  local user symbol host
  if [ "$SSH_TTY" ]; then # change prompt when in ssh
    # 󱥠 󰿆 󱦚 󱥡 󰉑 󱪧 󱦛
    user="%B%F{green}DBA %n%b%f"
    symbol="%B%F{cyan} %b%f"
    host="%F{magenta}%m%f" #(ssh)
    #host="@%F{magenta}%m%F{yellow}󱥠%f:" #(ssh)
  else
    user="%(!.%B%F{red}%n%b%f.%B%F{green}%n%b%f)"
    symbol="%(!.%B%F{red}%#%b%f.%B%F{cyan}>%b%f)"
    host=""
  fi
  
  venv="$(prompt_venv)"
  cwd="%B%F{cyan}%~%b%f"
  git_info="$(git_prompt_info)"

  line1="${venv}${user}: ${cwd} ${git_info}"
  line2="${host}${symbol} " 
  newline=$'\n'

  PROMPT="${line1}${newline}${line2}"
  RPS1="${return_code}"
}

precmd_functions+=(prompt_custom_theme_setup)

## can also use zsh hook to add to list of precmds
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd prompt_custom_theme_setup
################# Setting Zsh Prompt ###########################################
