" Common
set nocompatible
set encoding=utf8
set autoread
set ruler
set showcmd
set number
set backspace=indent,eol,start
set scrolloff=1
set sidescrolloff=5

" Disable visual bell
set noerrorbells visualbell t_vb=

" Disable backup and swap files
set nobackup
set nowritebackup
set noswapfile

" Wrapping
set linebreak
set showbreak=↪
set list
set listchars=tab:→\ ,trail:·

" Buffers
set hidden
set wildchar=<Tab> wildmenu wildmode=full

" Colors
syntax enable
set t_Co=256

" Undo
set history=1000
set undolevels=1000

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Filetypes
filetype plugin indent on

" Completion
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone

" Status line
set laststatus=2

" -- clear
set statusline=
" -- buffer number
set statusline +=%2*\ [%n]%*
" -- full path
set statusline +=%4*\ %<%F%*
" -- modified flag
set statusline +=%3*%m%*
" -- encoding
set statusline +=%1*%=\ %{''.(&fenc!=''?&fenc:&enc).''}\ %*
" -- file format
set statusline +=%1*%=%{&ff}%*
" -- file type
set statusline +=%1*%=%y%*
" -- current line
set statusline +=%2*%=%6l%*
" -- total lines
set statusline +=%1*/%*%3*%L%*
" -- virtual column number
set statusline +=%2*%5v\ %*

hi default link User1 Normal
hi default link User2 Identifier
hi default link User3 Special
hi default link User4 Title

" Return to last edit position when opening files
autocmd BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\   exe "normal! g`\"" |
			\ endif

" Remember last active buffer
let g:lastbuf = 1
au BufLeave * let g:lastbuf = bufnr('%')

" Remember last active tab
let g:lasttab = 1
au TabLeave * let g:lasttab = tabpagenr()

" Leader bindings
set notimeout
let mapleader = " "
nnoremap <Leader>b :exe "b ".g:lastbuf<CR>
nnoremap <Leader>t :exe "tabn ".g:lasttab<CR>
nnoremap <Leader>n :nohl<CR>

" Show leading spaces as gray dots
highlight Conceal guibg=NONE ctermbg=NONE ctermfg=Gray
match Conceal /\(^[ \t]*\)\@<= /

augroup HighlightLeadingSpaces
	autocmd BufWinEnter * setl conceallevel=2 concealcursor=nv
	autocmd BufWinEnter * syn match Conceal /\(^[ \t]*\)\@<= / containedin=ALL conceal cchar=·
	autocmd BufReadPre * setl conceallevel=2 concealcursor=nv
	autocmd BufReadPre * syn match Conceal /\(^[ \t]*\)\@<= / containedin=ALL conceal cchar=·
augroup END

" Highlight trailing whitespaces
highlight TrailingWhitespaces ctermbg=Red guibg=Red
match TrailingWhitespaces /\s\+$/

augroup HighlightTrailingWhitespaces
	autocmd BufEnter * match TrailingWhitespaces /\s\+$/
	autocmd BufWinEnter * match TrailingWhitespaces /\s\+$/
	autocmd WinEnter * match TrailingWhitespaces /\s\+$/
	autocmd InsertEnter * match TrailingWhitespaces /\s\+\%#\@<!$/
	autocmd InsertLeave * match TrailingWhitespaces /\s\+$/
	autocmd WinLeave * call clearmatches()
	autocmd BufWinLeave * call clearmatches()
	autocmd BufLeave * call clearmatches()
augroup END