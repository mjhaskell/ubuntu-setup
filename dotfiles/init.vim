" Neovim init.vim
" author: Mat Haskell
" contact: mhaskell9@gmail.com
" date: Oct 17 2018

"""""""" vim-plug plugin manager"""""""
call plug#begin('~/.config/nvim/plugged')

""""""""" Typing
Plug 'w0rp/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'

""""""""" Multi-entry selection UI. FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

""""""""" Utils
Plug 'scrooloose/nerdtree'
Plug 'mhask94/vim-nerdtree-syntax-highlight'
" Must manually change terminal profile to use a NERD FONT for icons to work
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/a.vim'
Plug 'airblade/vim-gitgutter'

""""""""" Style
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'

call plug#end()
"""""""""""""""""""""""""""""""""""""""

"""""""" Custom Settings """"""""""""""
" syntax highlighting and filetype specific features
syntax on
filetype on
filetype plugin on
filetype indent on

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
  
" Colorscheme
"set termguicolors
set background=dark

" Relative line numbering with absolute line number on current line
set relativenumber
set number
  
" Always display status bar
set laststatus=2

" swp files are the worst, disable them
set nobackup
set noswapfile

" Don't redraw while executing macros
set lazyredraw 

" allows pattern matching with special characters
set magic 

" show the cursor position all the time
set ruler   

" 80 character per line
set textwidth=80

" Highlight one column after limit
set colorcolumn=+1

" tabs are four spaces, smart tabbing
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

augroup cpp
  autocmd!
  set tabstop=2
  set shiftwidth=2
  set nosmartindent
augroup END

augroup py
  autocmd!
  set tabstop=4
  set shiftwidth=4
  set nosmartindent
augroup END

"""""""" Custom Keys """"""""""""""
" Set space for the leader
let mapleader = "\\"
nmap <space> <leader>
vmap <space> <leader>

" Escape Mappings for insert and visual modes
inoremap jk <esc>
vnoremap jk <esc>

" Mappings to move up and down faster
nnoremap J 10j
nnoremap K 10k
vnoremap J 10j
vnoremap K 10k

" Mappings to edit .vimrc/init.vim and source/save .vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Cpp stuff: nice curly braces
inoremap {<CR> {<CR>}<Esc>ko

" Clang-format
map <C-K> :pyf /usr/share/clang/clang-format-3.8/clang-format.py<cr>
imap <C-K> <c-o>:pyf /usr/share/clang/clang-format-3.8/clang-format.py<cr>

""""""""""" Plugins """"""""""""""""""
""""""""" ALE
" Use LSP linters
" Install cquery https://github.com/cquery-project/cquery
" Install pyls https://github.com/palantir/python-language-server
let b:ale_linters = {'cpp': ['cquery'], 'python':['pyls']}
let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1

" Show errors in airline status bar
let g:airline#extensions#ale#enabled = 1

"" Scroll through autocomplete options with Tab
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Use Ale to jump to definition, etc.
nnoremap <silent> gh :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gr :ALEFindReferences<CR>

"""""""""" Deoplete
let g:deoplete#enable_at_startup = 1
" Scroll through autocomplete options with Tab
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

"""""""""" UltiSnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" tab to expand snippets and Ctrl+j/Ctrl+k to move forward/backward"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Allow :UltiSnipsEdit command to split your window.
let g:UltiSnipsEditSplit="vertical"

"""""""""" NerdCommenter
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

"""""""""" NerdTree """"""""""""""""""
" Start nerdtree if start vim with no file specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Start nerdtree if start vim with a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Open/Close NerdTree with Ctrl + N
map <C-n> :NERDTreeToggle<CR>

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('py', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('cpp', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('hpp', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('h', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('ui', 'blue', 'none', 'blue', '#151515')
call NERDTreeHighlightFile('yaml', 'blue', 'none', 'blue', '#151515')
call NERDTreeHighlightFile('sh', 'Magenta', 'none', '#ff00ff', '#151515')

""""""""" VimAirline
" Note: If symbols don't appear install them with
" `sudo apt install fonts-powerline` Ubuntu
let g:airline_powerline_fonts = 1
let g:airline_theme = "dark"

""""""""" Tmuxline
" Note: this plugin is used to generate pretty formats for tmux that are saved
" and then loaded by tmux on startup. That way your tmux always looks nice, not
" just after you start vim.
let g:airline#extensions#tmuxline#enabled = 0
"""""""""""""""""""""""""""""""""""""

" Load all plugins now, generate help tags, errors and messages ignored
packloadall
silent! helptags ALL
