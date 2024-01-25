set nocompatible
set laststatus=2
set wildoptions=pum
set autoread
set number relativenumber "Line Numbers
augroup toggle_relative_number
autocmd InsertEnter * :setlocal number norelativenumber
autocmd InsertLeave * :setlocal relativenumber
set numberwidth=3 "Number width, set nuw
set autoindent 
set ruler "Always show current position
set showcmd "Shows what command I'm typing
set hlsearch "Highlight search
syntax on
let g:mapleader = ","
nnoremap <Leader>w :w<CR>
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

"Reset <C-a> mapping due to 'mswin.vim' mappings, see :verbose map <C-a>
unm <C-a>

" Trailing whitespace mapping
nnoremap <C-g> :%s/\s\+$//e<CR>
"
" Buffer switch
map <C-K> :bprev<CR>
map <C-J> :bnext<CR>

" make '.' work with visually selected lines
vnoremap . :normal.<CR>

" automate fold saving from current session
augroup auto_save_folds
    autocmd!
    " save / load folds if != empty && buffer is not new
    autocmd BufWritePost * if getfsize(expand("<afile>")) > 0 && !&l:buftype | mkview | endif
    autocmd BufWinEnter * if getfsize(expand("<afile>")) > 0 && !&l:buftype | silent loadview | endif
augroup END

" Fix textwidth on .text; defaulting to 78
autocmd FileType text set tw=79

"this sets tab as 4 space chars
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab 

"Text over 79 characters per line turns red
autocmd FileType javascript match Error /\%79v.\+/

"KX
set shell=pwsh
set backup
set undofile
set swapfile
set writebackup
set backupcopy=yes
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")
au BufWritePre * let &bex = '@' . strftime("%f.%H:%M")

set undodir=C:\dev\backups_global\undo\\
set backupdir=C:\dev\backups_global\backup\\
set dir=C:\dev\backups_global\swapfiles\\

"set spell spelllang=en_us "turn off if working with code

call plug#begin('C:\Users\Kontingent\vimfiles\plugged')
"Languages and file types.
Plug 'godlygeek/tabular'
let g:vim_markdown_conceal = 0

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_browser='C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
let g:mkdp_echo_preview_url = 1
function! g:EdgePreview(url)
    silent exe '!start edge ' . a:url
endfunction
let g:mkdp_browserfunc = 'EdgePreview'
let g:mkdp_preview_options = {
            \ 'mkit': {},
            \ 'katex': {},
            \ 'uml': {},
            \ 'maid': {},
            \ 'disable_sync_scroll': 0,
            \ 'sync_scroll_type': 'middle',
            \ 'hide_yaml_meta': 1,
            \ 'sequence_diagrams': {},
            \ 'flowchart_diagrams': {},
            \ 'content_editable': v:false,
            \ 'disable_filename': 0,
            \ 'toc': {}
            \ }
let g:mkdp_highlight_css = ''
let g:mkdp_port = 8080
let g:mkdp_page_title = '「${name}」'
let g:mkdp_filetypes = ['markdown']
let g:mkdp_combine_preview_auto_refresh = 1

Plug 'lambdalisue/fern.vim'
autocmd VimEnter * ++nested Fern . -reveal=% -drawer | wincmd l
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
let g:fern#renderer = "nerdfont"

Plug 'lambdalisue/fern-hijack.vim'
function! s:init_fern() abort
    nmap <buffer> <Plug>(fern-action-open:side) <Plug>(fern-action-open:right)
endfunction
augroup my-fern
    autocmd! *
        autocmd FileType fern call s:init_fern()
augroup END

Plug 'reedes/vim-pencil'
Plug 'dhruvasagar/vim-table-mode'
Plug 'mizlan/vim-and-cp'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
inoremap <silent><expr> <C-k>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><C-j> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

Plug 'lervag/vimtex'
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
let g:vimtex_syntax_conceal_disable = 1

Plug 'sheerun/vim-polyglot'
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
colorscheme spaceduck

Plug 'pedrohdz/vim-yaml-folds'
Plug 'dense-analysis/ale'
let g:ale_linters_explicit = 1
let g:ale_sign_column_always = 1
let b:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:ale_linters = {
            \   'python': ['pyright', 'pylint', 'flake8'],
            \   'javascript': ['tsserver', 'eslint'],
            \   'c': ['clangd'],
            \   'go': ['gopls'],
            \   'rust': ['rust-analyzer'],
            \   'ruby': ['solargraph'],
            \   'php': ['intelephense'],
            \   'haskell': ['haskell-language-server'],
            \   'dart': ['dart'],
            \   'powershell': ['powershell-editor-services'],
            \}
Plug 'Yggdroot/indentLine'
Plug 'vim-scripts/errormarker.vim'
Plug 'tpope/vim-dispatch'
Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<PageDown>'
let g:UltiSnipsJumpForwardTrigger = '<PageDown>'
let g:UltiSnipsJumpBackwardTrigger = '<PageUp>'

Plug 'honza/vim-snippets'
Plug 'universal-ctags/ctags-win32'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='alduin'

call plug#end()

augroup latex
    autocmd!
    autocmd FileType tex nnoremap <buffer> <F1> :w<CR>:call RunLualatex()<CR>
    autocmd FileType tex inoremap <buffer> <F1> <Esc>:w<CR>:call RunLualatex()<CR>a
    autocmd FileType tex nnoremap <buffer> <F2> :w<CR>:call RunPdflatex()<CR>
    autocmd FileType tex inoremap <buffer> <F2> <Esc>:w<CR>:call RunPdflatex()<CR>a
augroup end

function! RunLualatex()
    let b:dispatch='lualatex -interaction=nonstopmode --output-directory=pdfs --aux-directory=logs %'
    execute 'Dispatch!'
endfunction

function! RunPdflatex()
    let b:dispatch='pdflatex -interaction=nonstopmode --output-directory=pdfs --aux-directory=logs %'
    execute 'Dispatch!'
endfunction

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" Mappings
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap [ []<Left>
inoremap < <><Left>
nnoremap gj J
nnoremap <C-Down> <C-e> 
nnoremap <C-Up> <C-y> 

autocmd FileType java,c,php,asmx,asp,atp,cpp,markdown,js inoremap ' ''<Left>
autocmd FileType java,c,php,asmx,asp,atp,cpp,tex,markdown,js inoremap " ""<Left>
autocmd FileType tex imap <F4> <Esc>:w<CR>:!pdflatex %<CR>
autocmd FileType tex imap <F3> <Esc>:w<CR>:!lualatex %<CR>
autocmd FileType tex map <F6> :w<CR>:!pdflatex %<CR>
autocmd FileType tex map <F5> :w<CR>:!lualatex %<CR>
autocmd FileType java map <F1> <Esc>:w<CR>:!javac %<CR>:!java %<CR>
autocmd FileType markdown set ft=html.markdown

" Remap Page Up to Shift + K
noremap <S-K> <C-b>

" Remap Page Down to Shift + J
noremap <S-J> <C-f>

" Map Shift + Z to the function of Shift + K (open docs)
noremap <S-Z> <S-K>

:hi CursorLine   cterm=NONE ctermbg=234 ctermfg=white guibg=#1b1c36 guifg=white
:hi CursorColumn cterm=NONE ctermbg=234 ctermfg=white guibg=#1b1c36 guifg=white
:set cursorline! cursorcolumn!
:nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>
syntax enable

hi clear SpellBad
hi SpellBad cterm=underline
" Set style for gVim
hi SpellBad gui=undercurl

" Disables perma hlsearch
augroup disable_hlsearch_on_insert
    autocmd!
    autocmd InsertEnter * set nohlsearch
    autocmd CmdlineEnter / set hlsearch
    autocmd CmdlineLeave / set nohlsearch
augroup END

"autostore logs
function! LuatexC()
    let mainfile = expand('%:r')
    let texfile = mainfile.'.tex'
    let logdir = 'logs'
    let pdfdir = 'pdfs'

    if !isdirectory(logdir)
        call mkdir(logdir)
    endif

    if !isdirectory(pdfdir)
        call mkdir(pdfdir)
    endif

    let logfile = logdir.'/'.mainfile.'.log'
    let auxfile = logdir.'/'.mainfile.'.aux'
    let pdfpath = pdfdir.'/'.$mainfile.'*.pdf'

    exec 'silent !lualatex -output-directory='.logdir.' '.texfile
    exec 'silent !lualatex -output-directory='.logdir.' '.texfile
    exec 'silent !pdflatex -output-directory='.logdir.' '.texfile
    exec 'silent !pdflatex -output-directory='.logdir.' '.texfile
    exec 'silent !mv '.logdir.'/'.$mainfile.'*.pdf '.pdfdir
    redraw!
endfunction

hi DiffAdd gui=none guifg=NONE guibg=#bada9f
hi DiffChange gui=none guifg=NONE guibg=#e5d5ac
hi DiffDelete gui=bold guifg=#ff8080 guibg=#ffb0b0
hi DiffText gui=none guifg=NONE guibg=#8cbee2

" Folds config
set foldenable
set foldlevelstart=10 "Open most folds by default; 0 --> all folds closed
set foldnestmax=10 "Allow fold nesting; max value protects from too many folds
set foldmethod=manual "Definds the type of folding
hi Folded guifg=#864af9

" Stop-gap solution for error #852 from vim-plug
command! MyPlugUpdate :set shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugUpdate
command! MyPlugInstall :set shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugInstall
command! MyPlugClean :set shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugClean
command! MyPlugStatus :set shell=cmd.exe shellcmdflag=/c noshellslash guioptions-=! <bar> noau PlugStatus
