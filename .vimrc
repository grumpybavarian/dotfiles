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

" Python Syntax Highlighting
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'

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

" indent
set autoindent
set smartindent

" set leader key to comma
let mapleader = ","

" mouse mode
set mouse=a

" copy to system clipboard
set clipboard=unnamed

" relative numbers
set number relativenumber

" highlight current line
set cursorline

" colorscheme
colorscheme nord

" lightline setup
set laststatus=2

" python improved syntax highlighting
let g:python_highlight_all = 1

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype'  ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightLineFilename',
      \ }
      \ }

function! LightLineFilename()
	let name = ""
	let subs = split(expand('%'), "/")
	let i = 1
	for s in subs
		let parent = name
		if  i == len(subs)
			let name = parent . '/' . s
		elseif i == 1
			let name = s
		else
			let name = parent . '/' . strpart(s, 0, 2)
		endif
		let i += 1
	endfor
  return name
endfunction
" use gentle autopairs
let g:AutoPairsUseInsertedCount = 1

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime
au CursorHold * checktime

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
set hlsearch
set smartcase
"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" remove bad whitespaces on save
autocmd BufWritePre * :EraseBadWhitespace
autocmd FileType ruby,python autocmd BufWritePre <buffer> :%s/\($\n\s*\)\+\%$//e

"Speed up <Esc>
set ttimeout
set ttimeoutlen=25
set notimeout

" Persist undo
set undofile
"maximum number of changes that can be undone
set undolevels=99999
"maximum number lines to save for undo on a buffer reload
set undoreload=99999
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

" open NERDTree in current directory on Ctrl + T
nnoremap <C-t> :NERDTreeToggle %<CR>

" cursor moves to previous line if at the beginning + left key
set ww=<,>,h,l

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP
