set encoding=UTF-8
set termguicolors

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
Plug 'ap/vim-css-color'

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
Plug 'ryanoasis/vim-webdevicons'

" File Navigation
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

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
"autocmd BufRead * call SyncTree()

function! DecideToggling()
  if IsNERDTreeOpen()
    :NERDTreeToggle
  else
    :NERDTreeFind
    wincmd p
  endif
endfunction

function! OpenNTOnBufPost()
  :NERDTreeFind
  wincmd p
endfunction

nnoremap <C-t> :call DecideToggling()<CR>

let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeIgnore = ['^node_modules$', '^.git$']
let g:NERDTreeShowHidden = 1

" *************************************************************
" *                                                           *
" *                     ALLA AUTOMAGIC                        *
" *                                                           *
" *************************************************************
" open find file in NERDTree on tab change and on startup
au VimEnter * call OpenNTOnBufPost()
au TabEnter * call OpenNTOnBufPost()

"autocmd bufenter * if (winnr("$") > 1 && IsNERDTreeOpen()) | call OpenNTOnBufPost() | endif
" auto close NERDTree if no file is open
autocmd bufenter * if (winnr("$") == 1 && IsNERDTreeOpen()) | q | endif
autocmd bufenter * if (winnr("$") > 1 && IsNERDTreeOpen()) | call SyncTree() | endif

au BufReadPost *.erb set syntax=javascript

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

" *************************************************************
" *                                                           *
" *                     BOTTOM BAR CONFIG                     *
" *                                                           *
" *************************************************************
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
let g:ctrlsf_fold_result = 1
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_compact_position = 'bottom_inside'
let g:ctrlsf_compact_winsize = '50%'
let g:ctrlsf_auto_close = {
        \ "normal" : 1,
        \ "compact": 1
        \ }


let g:fzf_buffers_jump = 1
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{tmp/cache/*,node_modules/*,.git/*}"'
let $FZF_DEFAULT_OPTS=' --layout=reverse --preview="bat --style=numbers --color=always {}"'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(15)
  let width = float2nr(150)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 1

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

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

" only unbind l/r when not in insert mode
nnoremap <Left> :echo "Git gud noob! <-"<CR>
vnoremap <Left> :<C-u>:echo "Git gud noob! <-"<CR>
nnoremap <Right> :echo "Git gud noob! ->"<CR>
vnoremap <Right> :<C-u>echo "Git gud noob! ->"<CR>

" *************************************************************
" *                                                           *
" *                     REMAP KEYS                            *
" *                                                           *
" *************************************************************

nnoremap <silent> <C-p> :call fzf#vim#files('.', {'options': '--prompt ""'})<CR>
inoremap <silent> <C-p> <C-o>:Files<CR>

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
inoremap <C-Left> <C-o>:tabprevious<CR>
inoremap <C-Right> <C-o>:tabnext<CR>

" move line
inoremap <A-down> <ESC>:m+<CR>
inoremap <A-j> <ESC>:m+<CR>
inoremap <A-up> <ESC>:m-2<CR>
inoremap <A-k> <ESC>:m-2<CR>
nnoremap <A-j> :m+<CR>
nnoremap <A-down> :m+<CR>
nnoremap <A-k> :m-2<CR>
nnoremap <A-up> :m-2<CR>

" insert line before current line
nnoremap <leader>o O
inoremap <leader>o <C-o>O

" scroll up/down by one line in command and visual mode
nnoremap <C-Down> <C-y>
nnoremap <C-Up> <C-e>
nnoremap <C-k> <C-y>
nnoremap <C-j> <C-e>
inoremap <C-Down> <C-y>
inoremap <C-Up> <C-e>
inoremap <C-k> <C-y>
inoremap <C-j> <C-e>

nnoremap <silent> <S-Left> :vertical resize -1<CR>
nnoremap <silent> <S-Right> :vertical resize +1<CR>
nnoremap <silent> <S-Up> :resize -1<CR>
nnoremap <silent> <S-Down> :resize +1<CR>

" Open fugitive
nnoremap <C-g> :G<CR><C-w>L :vertical resize 50<Cr>

nnoremap <C-h> :GitGutterPreviewHunk<CR>

noremap <C-S>          :update<CR>
vnoremap <C-S>         <C-C>:update<CR>
inoremap <C-S>         <C-O>:update<CR><Esc>

noremap <C-A><C-Right> :split<CR>
nnoremap <A-w> :tabclose<CR>

" only in visual mode
inoremap jj <Esc>
inoremap kk <Esc>

" *************************************************************
" *                                                           *
" *                       SNIPPETS                            *
" *                                                           *
" *************************************************************

iabbrev clputs  5.times { puts '*** *** *** *** *** *** ***' }<CR>
                \puts "--> #{<C-O>ma }"<C-O>`a
iabbrev magic  # frozen_string_literal: true<CR>

" *************************************************************
" *                                                           *
" *                       COMMANDS                            *
" *                                                           *
" *************************************************************

" NERDTree shortcut commands
nmap <leader>r :NERDTreeRefreshRoot<CR>
" global search
nmap <leader>f <Plug>CtrlSFPrompt

" trim trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

nnoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
inoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Case changes
nnoremap <Leader>u gUiw
inoremap <Leader>u gUiw
vnoremap <Leader>u gUiw

nnoremap <Leader>d guiw
inoremap <Leader>d guiw
vnoremap <Leader>d guiw

nnoremap <Leader>- ~h
inoremap <Leader>- ~h

function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction

nmap <Leader>gh :call GitGutterNextHunkCycle()<CR>

