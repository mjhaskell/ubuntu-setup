local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if [[ $UID -eq 0 ]]; then
    local user='%{$terminfo[bold]$fg[red]%}%n%{$reset_color%}'
    local user_symbol='%{$terminfo[bold]$fg[red]%}#%{$reset_color%}'
else
    local user='%{$terminfo[bold]$fg[green]%}%n%{$reset_color%}'
    local user_symbol='%{$terminfo[bold]$fg[cyan]%}>%{$reset_color%}'
fi

if [ "$SSH_TTY" ]; then
    # 󱥠󰿆󱦚󱥡󰉑󱪧󱦛
    #local host='@%{$fg[magenta]%}%m%{$fg[yellow]%}󱥠%{$reset_color%}:' #(ssh)
    local host='%{$fg[magenta]%}%m%{$reset_color%}' #(ssh)
    local user_symbol='%{$terminfo[bold]$fg[cyan]%} %{$reset_color%}'
    local user='%{$terminfo[bold]$fg[green]%}DBA %n%{$reset_color%}'
else
    local host=''
fi

local current_dir='%{$terminfo[bold]$fg[cyan]%}%~%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'

#PROMPT="${user}${host}: ${current_dir} ${git_branch}
PROMPT="${user}: ${current_dir} ${git_branch}
${host}%B${user_symbol}%b "
RPS1="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}) %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%})"

precmd() {
    #local ret="$? ↵"
    #echo $VIRTUAL_ENV
    #echo $ret
    #echo ${#ret}
    #echo
}

