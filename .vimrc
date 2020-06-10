if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Fugitive & git-gutter for git stuff
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" NerdTree & Commenter
Plug 'scrooloose/nerdtree'
Plug 'preservim/nerdcommenter'

" Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" AG (Silver Searcher)
Plug 'rking/ag.vim'

" Lightline
Plug 'itchyny/lightline.vim'

" Colorschemes
" Plug 'flazz/vim-colorschemes'
Plug 'arcticicestudio/nord-vim'

" Surround
Plug 'tpope/vim-surround'

" Gentle Autopairs
Plug 'vim-scripts/auto-pairs-gentle'

" show hex colors
Plug 'chrisbra/Colorizer'

" easily move around
Plug 'easymotion/vim-easymotion'

" remove bad whitespaces automatically
Plug 'bitc/vim-bad-whitespace'

" better start screens
Plug 'mhinz/vim-startify'

" multiple cursors
Plug 'terryma/vim-multiple-cursors'

call plug#end()

" backspace sanity
set backspace=indent,eol,start

" set leader key to comma
let mapleader = ","

" mouse mode
set mouse=a

" copy to system clipboard
set clipboard=unnamed

" relative numbers
set relativenumber

" highlight current line
set cursorline

" colorscheme
colorscheme nord

" lightline setup
set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype'  ] ]
      \ },
      \ }

" use gentle autopairs
let g:AutoPairsUseInsertedCount = 1

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" allow git blame toggle
nmap <expr> <C-b> &filetype ==# 'fugitiveblame' ? "gq" : ":Gblame\r"

" customise start screen
let g:startify_custom_header = []

" Ripgrep + FZF
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --hidden --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -bang -nargs=? -complete=dir HFiles
  \ call fzf#vim#files(<q-args>, {'source': 'ag --hidden --ignore .git -g ""'}, <bang>0)
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" nenoremap <C-f> RipgrepFzf()
map <C-g> :RG<CR>
map <C-f> :HFiles<CR>

" commenter setting
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" some key mappings for easier saving and quitting
nmap ,s :w<CR>
nmap ,wq :wq<CR>

" source COC config
source $HOME/dotfiles/coc_config.vim

" always show tabline
set showtabline=2

" incsearch
set incsearch

" remove bad whitespaces on save
autocmd BufWritePre * :EraseBadWhitespace

"Speed up <Esc>
set ttimeout
set ttimeoutlen=25
set notimeout

" Persist undo
set undofile
"maximum number of changes that can be undone
set undolevels=9999
"maximum number lines to save for undo on a buffer reload
set undoreload=9999
" set location
set undodir=$HOME/.vimundo//

" avoid creating .swp files
set noswapfile

" Always show the signcolumn, otherwise it would shift the text each time
set signcolumn=yes

" Reopen at same position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif