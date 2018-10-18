" Neovim init.vim
" author: Mat Haskell
" contact: mhaskell9@gmail.com
" date: Oct 17 2018

" The Tutor told me to puth the next 3 lines in this file (idk if needed)
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

" vim-plug plugin manager
call plug#begin('~/.config/nvim/plugged')

" Typing
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Utils
Plug 'scrooloose/nerdtree'

" Style
Plug 'edkolev/tmuxline.vim'

"""""""" Custom Settings """"""""""""""
" Always copy and paste to clipboard
set clipboard+=unnamedplus

" Use xclip for clipboard
" sudo apt install xclip
let g:clipboard = {
  \   'name': 'xclip-xfce4-clipman',
  \   'copy': {
  \      '+': 'xclip -selection clipboard',
  \      '*': 'xclip -selection clipboard',
  \    },
  \   'paste': {
  \      '+': 'xclip -selection clipboard -o',
  \      '*': 'xclip -selection clipboard -o',
  \   },
  \   'cache_enabled': 1,
  \ }
