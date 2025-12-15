## options
# https://zsh.sourceforge.io/Doc/Release/Options.html
# https://zsh.sourceforge.io/Doc/Release/Expansion.html#Filename-Expansion

setopt auto_pushd
setopt cd_silent

setopt always_to_end
setopt complete_aliases
setopt complete_in_word
setopt glob_complete
setopt list_packed

setopt rc_expand_param # possibly remove

setopt extended_history
# no hist_beep
setopt hist_expire_dups_first
setopt hist_fcntl_lock # personal machines only
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
# hist_lex_words
setopt hist_no_store
# setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

setopt correct_all # set sh var CORRECT_IGNORE_FILE to a pattern to match
                   # file names that will never be offered as corrections
# unsetopt correct_all
# no flow_control # OMZ turns off flow_control
setopt interactive_comments
# no rm_star_silent
setopt rm_star_wait

setopt local_options
setopt pipe_fail
