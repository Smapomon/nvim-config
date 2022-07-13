set encoding=UTF-8
set termguicolors " use the terminal colorscheme so that they padding matches the vim colorscheme
set showtabline=2 " always show tabs

hi Directory guifg=#ff0000 ctermfg=green
hi CursorLine cterm=NONE ctermbg=darkgrey ctermfg=cyan

set ignorecase
set smartcase
set autoread
set cursorline
set clipboard=unnamed " use system clipboard
set nu rnu " relative line numbers are better for navigation

" splits to right and below feel more natural
set splitbelow
set splitright

" disable multiple statusbars
set laststatus=3

" tab titles
let &titlestring = @&
set title

set tags=tags; " tags file withing the current directory

call plug#begin()
Plug 'vim-scripts/L9'

" theme (bleep bloop)
Plug 'joshdick/onedark.vim'
Plug 'itchyny/lightline.vim'
Plug 'jacoborus/tender.vim'
Plug 'ryanoasis/vim-webdevicons'
Plug 'kyazdani42/nvim-web-devicons' " for coloured icons

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
"Plug 'scrooloose/syntastic'
Plug 'dense-analysis/ale'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'sheerun/vim-polyglot'
"Plug 'ngmy/vim-rubocop'
Plug 'ap/vim-css-color'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" git integrations
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'christoomey/vim-conflicted'
Plug 'niklaas/lightline-gitdiff'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'
Plug 'akinsho/git-conflict.nvim'

" File Navigation
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'kyazdani42/nvim-tree.lua'

" auto completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-scripts/CmdlineComplete'

" comment code
Plug 'preservim/nerdcommenter'

" surround operations
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" snippets
Plug 'marcweber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

call plug#end()

" Snippets config
let g:snippets_dir="C:\Users\sampo\AppData\Local\nvim-data\plugged\vim-snippets\snippets\,C:\Users\sampo\AppData\Local\nvim\snippets"
let g:snipMate = { 'snippet_version' : 1 }

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

autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
"autocmd BufRead * call OpenCocExplorer()

" *************************************************************
" *                                                           *
" *                     LUA SETUPS                            *
" *                                                           *
" *************************************************************

lua << EOF
require"nvim-treesitter.configs".setup {
  ensure_installed = "all",
  sync_install     = false,


  highlight = {
    enable                             = true,
    additional_vim_regex_highluighting = true,
  },

  indent = {
    enable = true,
  }
}

require"nvim-tree".setup {
  disable_netrw      = true,
  hijack_netrw       = true,
  open_on_setup      = false,
  open_on_setup_file = false,
  update_cwd         = true,
  open_on_tab        = true,
  reload_on_bufenter = true,
  hijack_cursor      = true,

  renderer                 = {
    highlight_git          = true,
    highlight_opened_files = "none",
    full_name              = true,
    group_empty            = true,

    icons           = {
      git_placement = "before",
      padding       = "  ",
    }
  },

  hijack_directories = {
    enable          = true,
    auto_open       = true
  },

  view = {
    width = 30
  },

  git = {
    ignore = false
  },

  filters = {
    dotfiles = false
  },

  update_focused_file = {
    enable = true,
  },
}

vim.opt.laststatus = 3
EOF


au VimEnter * call OpenFileTree()

function! OpenFileTree()
  NvimTreeToggle
  wincmd p
endfunction

nnoremap <C-t> :call OpenFileTree()<CR>

" assembly files with nasm highlighting
augroup assembly_ft
  au!
  autocmd BufNewFile,BufRead *.asm set syntax=nasm filetype=nasm
augroup END

" *************************************************************
" *                                                           *
" *                     EDITOR WARNINGS                       *
" *                                                           *
" *************************************************************
set statusline+=%#warningmsg#
set statusline+=%*
set signcolumn=yes

let g:ale_floating_preview       = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
let g:ale_hover_cursor           = 1
let g:ale_set_balloons           = 1
let g:ale_cursor_detail          = 1
let g:ale_set_quickfix           = 0

let g:ale_pattern_options = {
\   '.*secure_headers\.rb$': {'ale_enabled': 0},
\   'Gemfile\.lock$': {'ale_enabled': 0},
\   '.*schema\.rb': {'ale_enabled':0}
\}

" *************************************************************
" *                                                           *
" *                     ALLA AUTOMAGIC                        *
" *                                                           *
" *************************************************************

au BufReadPost *.erb set syntax=javascript
au BufEnter Gemfile.lock set ft=ruby

" syntax configs
syntax on
set shiftwidth=2
set autoindent
set numberwidth=6
hi LineNr term=bold cterm=NONE ctermbg=NONE gui=NONE

" always prefer unix line endings
set fileformat=unix
set fileformats=unix,dos
"set nobinary

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
      \		  	  ['readonly', 'modified', 'gitbranch'],
      \		  	  ['gitdiff'],
      \		  	  ['relativepath'],
      \			],
      \		'right': [ ['lineinfo'], ['percent'], ['filetype', 'fileformat', 'fileencoding'] ],
      \ },
      \ 'inactive': {
      \		'left': [ ['filename', 'gitversion'] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'lineinfo': 'LightlineLineinfo'
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

function! LightlineLineinfo() abort
  let l:current_line = printf('%-3s', line('.'))
  let l:max_line = printf('%-3s', line('$'))
  let l:lineinfo = ' ' . l:current_line . '/' . l:max_line

  return l:lineinfo
endfunction

au VimEnter * call lightline#update()

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
let g:ctrlsf_default_root = 'project'
let g:ctrlsf_auto_close = {
        \ "normal" : 1,
        \ "compact": 1
        \ }


let g:fzf_buffers_jump = 1
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{tmp/cache/*,node_modules/*,.git/*,public/test/upload_items/*}"'
let $FZF_DEFAULT_OPTS=' --layout=reverse'
"let $FZF_DEFAULT_OPTS=' --layout=reverse --preview="bat --style=numbers --color=always {}"'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(30)
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

" update on vim enter because of lightline bug that does not initialize the bottom bar correctly
autocmd FocusGained * call lightline#update()

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

nnoremap <silent> <C-p> :call fzf#vim#files('.', {'options': '--prompt "" --layout=reverse --preview="bat --style=numbers --color=always {}"'})<CR>
"inoremap <silent> <C-p> <C-o>:call fzf#vim#files('.', {'options': '--prompt ""'})<CR>

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
inoremap <leader>O <C-o>o

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

noremap <A-Right> :vsplit<CR>
nnoremap <A-w> :tabclose<CR>
nnoremap <Leader>tc :tabclose<CR>

" only in insert mode
inoremap jj <Esc>
inoremap kk <Esc>

" navigate quickfix list forward
nnoremap <leader>n :cn<CR>
vnoremap <leader>n <C-C>:cn<CR>
inoremap <leader>n <C-O>:cn<CR><Esc>
nnoremap <leader>N :lnext<CR>
vnoremap <leader>N <C-C>:lnext<CR>
inoremap <leader>N <C-O>:lnext<CR><Esc>

" navigate quickfix list back
nnoremap <leader>p :cp<CR>
vnoremap <leader>p <C-C>:cp<CR>
inoremap <leader>p <C-O>:cp<CR><Esc>
nnoremap <leader>P :lprevious<CR>
vnoremap <leader>P <C-C>:lprevious<CR>
inoremap <leader>P <C-O>:lprevious<CR><Esc>

" Hex read & write binary files
nmap <Leader>hr :%!xxd<CR> :set filetype=xxd<CR>
nmap <Leader>hw :%!xxd -r<CR> :set binary<CR> :set filetype=<CR>

" visual search
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

nmap <Leader>t= :Tabularize /=<CR>
vmap <Leader>t= :Tabularize /=<CR>
nmap <Leader>t: :Tabularize /:\zs<CR>
vmap <Leader>t: :Tabularize /:\zs<CR>

" *************************************************************
" *                                                           *
" *                       SNIPPETS                            *
" *                                                           *
" *************************************************************

" MOVED TO SNIPMATE

" *************************************************************
" *                                                           *
" *                       COMMANDS                            *
" *                                                           *
" *************************************************************

" global search
nmap <leader>f :Rg<CR>

" trim trailing whitespace
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" subsitute word under cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
inoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" open rubocop list
"nnoremap <Leader>ö :RuboCop<CR>

" Case changes (in visual mode only change selection)
nnoremap <Leader>u gUiw
inoremap <Leader>u gUiw
vnoremap <Leader>u gU

nnoremap <Leader>d guiw
inoremap <Leader>d guiw
vnoremap <Leader>d guiw

nnoremap <Leader>- ~h
inoremap <leader>- ~h

nnoremap <Leader>yy ^yg_

function! ReplaceMatch()
  call inputsave()
  let start_val = input('Find: ')
  call inputrestore()

  call inputsave()
  let end_val = input('Replace: ')
  call inputrestore()

  let exec_command = "cfdo %s/" . start_val . "/" . end_val . "/ | update<CR>"
  echo "-->"
  echo exec_command
  execute exec_command
endfunction
nmap <leader>r :cfdo %s///<left><left>
"nmap <leader>r :call ReplaceMatch()<CR>

function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction

nmap <Leader>gh :call GitGutterNextHunkCycle()<CR>

inoremap <silent> =   =<Esc>:call <SID>align('=')<CR>a
function! s:align(aa)
  let p = '^.*\s'.a:aa.'\s.*$'
  if exists(':Tabularize') && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^'.a:aa.']','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*'.a:aa.':\s*\zs.*'))
    exec 'Tabularize/'.a:aa.'/l1'
    normal! 0
    call search(repeat('[^'.a:aa.']*'.a:aa,column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction


function! CycleEOL()
  let eol_format   = &ff
  let eol_dict     = {'unix': 'dos', 'dos': 'unix', 'mac': 'unix'}
  let new_eol      = eol_dict[eol_format]
  let exec_command = "e! ++ff=" . new_eol
  execute exec_command
endfunction

command EOL call CycleEOL()

function! RemoveEOLMarks()
  let eol_sub_command = "%s///"
  execute eol_sub_command
endfunction

command EOLSUB call RemoveEOLMarks()

command! Cclear cexpr []
