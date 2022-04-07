set encoding=UTF-8

hi Directory guifg=#ff0000 ctermfg=green
hi CursorLine cterm=NONE ctermbg=darkgrey ctermfg=cyan

set ignorecase
set smartcase
set autoread
set cursorline
set clipboard=unnamed

" set line numbering
set nu rnu

" set tab titles
let &titlestring = @&
set title

set tags=tags; " tags file withing the current directory

call plug#begin()
Plug 'vim-scripts/L9'

" theme (bleep bloop)
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'jacoborus/tender.vim'

" snippets + magic
Plug 'rstacruz/sparkup', {'rtp':'vim'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'sjl/gundo.vim'
Plug 'christoomey/vim-system-copy'
Plug 'dyng/ctrlsf.vim'

" syntax highlighting + lint/hint
Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'mattn/emmet-vim'
Plug 'scrooloose/syntastic'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'sheerun/vim-polyglot'
Plug 'ngmy/vim-rubocop'

" git integrations
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'christoomey/vim-conflicted'
Plug 'niklaas/lightline-gitdiff'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" NERDTree Integrations
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" works with Clap
Plug 'ryanoasis/vim-webdevicons'

" File Navigation
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }

" auto completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'

" comment code
Plug 'preservim/nerdcommenter'

" surround operations
Plug 'tpope/vim-surround'

call plug#end()

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-yaml',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-solargraph',
  \ 'coc-tsserver',
  \ 'coc-pyright',
  \ 'coc-pairs',
  \ 'coc-git',
  \ 'coc-eslint',
  \ ]

au BufReadPost *.erb set syntax=javascript

" nerdtree config
" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and were not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()

function! DecideToggling()
  if IsNERDTreeOpen()
    :NERDTreeToggle
  else
    :NERDTreeFind
  endif
endfunction

nnoremap <C-t> :call DecideToggling()<CR>

au VimEnter * NERDTreeFind

let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeIgnore = ['^node_modules$', '^.git$']
" let g:NERDTreeMapOpenInTab = '<ENTER>'

" auto close NERDTree if no file is open
autocmd bufenter * if (winnr("$") == 1 && IsNERDTreeOpen()) | q | endif

" jump to primary window
autocmd VimEnter * wincmd p

" syntax configs
syntax on
set shiftwidth=2
set autoindent
set smartindent
set numberwidth=6
hi LineNr term=bold cterm=NONE ctermbg=NONE gui=NONE

" always use unix line endings
set ff=unix

" theme configs
colorscheme onedark


" show trailing whitespace
hi ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" coloring for popups
"highlight CocHintFloat guibg=darkred guifg=#ff0000
"hi Pmenu ctermfg=250 ctermbg=23 guifg=#ffffff guibg=#005f5f
"hi PmenuSel cterm=underline ctermfg=250 ctermbg=59 gui=underline guifg=#ffffff guibg=#5f5f5f

" lightline configs
let g:lightline= {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \		'left': [ ['mode', 'paste'],
      \		  	  ['gitbranch', 'readonly', 'filename', 'modified'],
      \		  	  ['gitdiff'],
      \			],
      \		'right': [ ['lineinfo'], ['filetype'] ],
      \ },
      \ 'inactive': {
      \		'left': [ ['filename', 'gitversion'] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ 'component_expand': {
      \	 'gitdiff': 'lightline#gitdiff#get',
      \ },
      \ 'component_type': {
      \	 'gitdiff': 'middle',
      \ },
      \ }

let g:lightline#gitdiff#inidicator_added = 'Add: '
let g:lightline#gitdiff#inidicator_modified = 'Mod: '
let g:lightline#gitdiff#inidicator_removed = 'Del: '
let g:lightline#gitdiff#separator = ' '
let g:lightline#gitdiff#show_empty_indicators = 1

let g:lightline.component_function = { 'lineinfo': 'LightlineLineinfo' }

function! LightlineLineinfo() abort
  let l:current_line = printf('%-3s', line('.'))
  let l:max_line = printf('%-3s', line('$'))
  let l:lineinfo = ' ' . l:current_line . '/' . l:max_line

  return l:lineinfo
endfunction

filetype plugin on

" *************************************************************
" *                                                           *
" *                     FUZZY CONFIGS                         *
" *                                                           *
" *************************************************************

let mapleader = ","

let g:ctrlsf_auto_focus = {
  \ 'at': 'start',
  \}

"let g:ctrlsf_auto_preview = 1
let g:ctrlsf_default_view_mode = 'compact'
"let g:ctrlsf_position = 'bottom'

"let s:is_win = has('win32') || has('win64')
"if s:is_win
    "nmap <C-z> <Nop>
"endif

let g:clap_current_selection_sign = { 'text': '->', 'texthl': 'ClapSelectedSign', 'linehl': 'ClapSelected' }

" *************************************************************
" *                                                           *
" *                  UNBIND ARROW KEYS                        *
" *                                                           *
" *************************************************************
nnoremap <Up> :echo "Git gud noob! ^"<CR>
vnoremap <Up> :<C-u>:echo "Git gud noob! ^"<CR>
inoremap <Up> <C-o>:echo "Git gud noob! ^"<CR>

nnoremap <Down> :echo "Git gud noob! v"<CR>
vnoremap <Down> :<C-u>echo "Git gud noob! v"<CR>
inoremap <Down> <C-o>:echo "Git gud noob! v"<CR>

" *************************************************************
" *                                                           *
" *                     REMAP KEYS                            *
" *                                                           *
" *************************************************************
nmap <leader>f <Plug>CtrlSFPrompt

" remaps for ease of use
nnoremap <A-j> :m+<CR>
nnoremap <A-down> :m+<CR>
nnoremap <A-k> :m-2<CR>
nnoremap <A-up> :m-2<CR>

nnoremap <C-p> :Clap files<CR>
inoremap <C-p> <C-o>:Clap files<CR>

" move line
inoremap <A-down> <ESC>:m+<CR>
inoremap <A-j> <ESC>:m+<CR>
inoremap <A-up> <ESC>:m-2<CR>
inoremap <A-k> <ESC>:m-2<CR>

" scroll up/down by one line
nnoremap <C-Down> <C-e>
inoremap <C-Down> <C-e>
nnoremap <C-k> <C-e>
inoremap <C-k> <C-e>

nnoremap <C-Up> <C-y>
inoremap <C-Up> <C-y>
nnoremap <C-j> <C-y>
inoremap <C-j> <C-y>

" comment/uncomment
vmap <C-k><C-m> <plug>NERDCommenterComment
vmap <C-k><C-u> <plug>NERDCommenterUncomment

nmap <C-k><C-m> <plug>NERDCommenterComment
nmap <C-k><C-u> <plug>NERDCommenterUncomment

" trim trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" resize split vim panes
nnoremap <silent> <S-Left> :vertical resize -1<CR>
nnoremap <silent> <S-Right> :vertical resize +1<CR>
nnoremap <silent> <S-Up> :resize -1<CR>
nnoremap <silent> <S-Down> :resize +1<CR>

" Open fugitive
nnoremap <C-g> :G<CR>

" open hunk preview
nnoremap <C-h> :GitGutterPreviewHunk<CR>
inoremap <C-h> :GitGutterPreviewHunk<CR>

" save file
noremap <C-S>          :update<CR>
vnoremap <C-S>         <C-C>:update<CR>
inoremap <C-S>         <C-O>:update<CR><Esc>

" split window horizontally
noremap <C-A><C-Right> :split<CR>

" close tabs
nnoremap <A-w> :tabclose<CR>

inoremap jj <Esc>


" *************************************************************
" *                                                           *
" *                       SNIPPETS                            *
" *                                                           *
" *************************************************************

iabbrev clputs  5.times { puts '*** *** *** *** *** *** ***' }<CR>
                \puts "--> #{<C-O>ma }"<C-O>`a

