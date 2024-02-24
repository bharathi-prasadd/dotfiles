"               --------- GENERAL COMMANDS ---------               "

set showmode                        "show mode at the bottom(insert/visual)
set showmatch                       "show bracket match if visible
set smartcase                       "ignore case for search iff search contains only lower case alphabets
set mouse=a                         "enable mouse for normal and visual mode
set incsearch                       "Enable incremental search
set tabstop=4                       "Tab behaviour
set shiftwidth=4                    "
set expandtab                       "
set softtabstop=4                   "
set undofile                        "undos persist
set scrolloff=10                    "Always have 10 lines above and below the current line
set clipboard+=unnamedplus          "use system clipboard by default
set filetype                        "enable filetype detection
set termguicolors
set nrformats=                      "treat numbers with leading 0s as decimals

" set python3 interpreter path
let g:python3_host_prog = '/home/rumi/.config/nvim/venv/bin/python'

"Put all autocmmands into this to ensure theyre only sourced once
if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    au BufEnter * set fo-=c fo-=r fo-=o "disable auto commenting of new lines
    au FileType help wincmd L           "open help in vertical split
    au BufWritePre * :%s#\($\n\s*\)\+\%$## "Remove all trailing lines at the end of the file
    "Open all files in the position of last edit
    autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
    "Enable spell checking only in the following files
    let spellable = ['markdown', 'gitcommit', 'txt', 'text', 'liquid', 'rst']
    autocmd BufEnter * if index(spellable, &ft) < 0 | set nospell | else | set spell | endif
    au BufWritePre *.py  :call BlackSync()
endif


"               ---------KEYBOARD SHORTCUTS---------

let mapleader=','

" disable hl with 2 esc
nnoremap <silent><esc> <esc>:noh<CR><esc>
nnoremap <silent><C-l> :set relativenumber!<CR>
nnoremap <silent> <leader><C-L> :set number!<CR>
nnoremap <enter> o<esc>
nnoremap <S-enter> O<esc>
nnoremap <leader>r :source ~/.config/nvim/init.vim<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :bd<CR>
nnoremap <leader>e :PlugInstall<CR>
nnoremap <leader>f :Files
nnoremap <leader>F :Files ~<CR>
nmap     <Tab>     :bnext<CR>
nmap     <S-Tab>   :bprev<CR>
" exit insert mode by typing jk
inoremap jk <esc>
" call black to format python
nnoremap <buffer><silent> <leader>x <cmd>call Black()<cr>
" Add commands to insert and remove to-dos in .md files
nnoremap <leader>i :s/\[\ \]/\[x\]<CR>
nnoremap <leader>ic :%s/\[\ \]/\[x\]/c<CR>
nnoremap <leader>I O- [ ]<Esc>
nnoremap <leader>m :MarkdownPreview<CR>


"               ---------PLUGINS---------               "

call plug#begin()

"Statusline plugin vim and themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Rainbow paranthesis matching
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

"startup screen for vim
Plug 'mhinz/vim-startify'

"plugin for better syntax highlighting
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }

"smooth scrolling
Plug 'psliwka/vim-smoothie'

"UNIX commands
Plug 'tpope/vim-eunuch'

"Catpuccin theme
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

"fzf integration
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" move visual selection
Plug 'Jorengarenar/vim-MvVis'

" highlight matching html tags
Plug 'gregsexton/MatchTag'

" Black for formatting python
Plug 'averms/black-nvim', {'do': ':UpdateRemotePlugins'}

" Commentary for commenting out lines
Plug 'tpope/vim-commentary'

" Fugitive for git integration
Plug 'tpope/vim-fugitive'

" Markdown Preview with vim
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" coc-nvim for autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"               ---------PLUGIN MANAGEMENT---------               "

"semshi
let g:semshi#filetype = ['python']                  "Call plugin only if filetype is python
let g:semshi#excluded_hl_groups = ['local']         "exclude local in hl groups
let g:semshi#mark_selected_nodes = 1                "highlight all nodes related to one currently selected
let g:semshi#no_default_builtin_highlight = v:true  "disable vim's syntax highlighting for python files
let g:semshi#simplify_markup = v:true               "simplify syntax highlighting for other elements
let g:semshi#error_sign = v:true                    "notify if errors pop up
let g:semshi#error_sign_delay = 3.5                 "wait for 1.5s to notify
let g:semshi#always_update_all_highlights = v:false "only update highlights that have been changed
let g:semshi#tolerate_syntax_errors = v:true        "tolerate minor syntax errors (small overhead)
let g:semshi#update_delay_factor = 0.0001           "factors will be updated every (factor * number of lines) seconds
let g:semshi#self_to_attribute = v:true             "when self.{attr} is selected semshi will refer to attr

" ---------------------------------------------------------------------------------- "

"smoothie
let g:smoothie_experimental_mappings = 1            "enable gg and G

" ---------------------------------------------------------------------------------- "

"startify

let g:startify_padding_left = 10
let g:startify_session_persistence = 1
let g:startify_enable_special = 0
let g:startify_change_to_vcs_root = 1
let g:startify_lists = [
    \ { 'type': 'dir'       },
    \ { 'type': 'files'     },
    \ { 'type': 'sessions'  },
    \ { 'type': 'bookmarks' },
    \ { 'type': 'commands' },
    \ ]

"bookmark
let  g:startify_bookmarks =  [
    \ {'v': '~/.config/nvim/init.vim'},
    \ {'i': '~/.config/i3/config' },
    \ {'z': '~/.zshrc' },
    \ {'c': '~/cse/C_programs/ritchie'},
    \ {'a': '~/.zsh_aliases'},
    \ {'t': '~/.tmux.conf'},
    \ ]

"custom commands
let g:startify_commands = [
    \ {'ch': ['Health Check', ':checkhealth']},
    \ {'ps': ['Plugins status', ':PlugStatus']},
    \ {'pu': ['Update vim plugins',':PlugUpdate | PlugUpgrade']},
    \ {'uc': ['Update coc Plugins', ':CocUpdate']},
    \ {'h':  ['Help', ':help']},
    \ ]

let g:ascii = [
 \ '',
 \ '                                                    ▟▙            ',
 \ '                                                    ▝▘            ',
 \ '            ██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖',
 \ '            ██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██',
 \ '            ██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██',
 \ '            ██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██',
 \ '            ▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀',
 \ '',
 \ '',
 \ '',
 \]


let g:startify_custom_header = g:ascii + startify#pad(startify#fortune#cowsay())

" ---------------------------------------------------------------------------------- "
" fzf
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'border': 'sharp' } }
let g:fzf_tags_command = 'ctags -R'

let $FZF_DEFAULT_OPTS = '--inline-info'
let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**' --glob '!build/**' --glob '!.dart_tool/**' --glob '!.idea' --glob '!node_modules'"

nmap <leader>b :Buffers<CR>
nmap <leader>c :Commands<CR>
nmap <leader>bl :Lines<CR>
nmap <leader>z <plug>(fzf-maps-n)

" ---------------------------------------------------------------------------------- "
" Catppucin

lua << EOF
local catppuccin = require("catppuccin")
EOF

"Load catppuccin
let g:catppuccin_flavour = "macchiato" ", frappe, macchiato, mocha, macchiato
colorscheme catppuccin


"               ---------STATUS LINE FILE---------               "
"source ~/.config/nvim/statusline.vim
