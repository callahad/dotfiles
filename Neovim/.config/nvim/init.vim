set nocompatible " (Neovim Default)

" Vim-Plug Setup
call plug#begin('~/.cache/nvim/plugged')
    " Colorschemes
    Plug 'jonathanfilip/vim-lucius'
        let g:lucius_style = 'dark'
        let g:lucius_contrast = 'low'
        let g:lucius_contrast_bg = 'high'
        let g:lucius_no_term_bg = 1
    Plug 'https://bitbucket.org/kisom/eink.vim.git'
    Plug 'robertmeta/nofrils'
    Plug 'ggustafsson/Static-Color-Scheme'

    " Editing Behavior
    Plug 'editorconfig/editorconfig-vim'
    Plug 'Raimondi/delimitMate'
        let delimitMate_expand_cr    = 1
        let delimitMate_expand_space = 1
        au FileType python       let b:delimitMate_nesting_quotes = ['"', "'"]
        au FileType markdown,mkd let b:delimitMate_nesting_quotes = ['`']
        au FileType clojure      let b:delimitMate_quotes = '"'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'

    " Features
    Plug 'mattn/emmet-vim'
        let g:user_emmet_install_global = 0
        au FileType html,css EmmetInstall
    Plug 'scrooloose/nerdtree'
        map <leader>f :NERDTreeToggle<CR>
        let g:NERDTreeRespectWildIgnore = 1
    Plug 'majutsushi/tagbar'
        map <leader>t :TagbarToggle<CR>

    " File Types
    " See sheerun/vim-polyglot for more suggestions
    Plug 'cespare/vim-toml'
    Plug 'chikamichi/mediawiki.vim'
    Plug 'fatih/vim-go'
        let g:go_fmt_fail_silently = 1
        au BufRead,BufNewFile *.sigil setlocal filetype=gotexttmpl
    Plug 'Glench/Vim-Jinja2-Syntax'
    Plug 'hail2u/vim-css3-syntax'
        au BufRead,BufNewFile *.css setlocal filetype=scss
    Plug 'hdima/python-syntax'
    Plug 'hynek/vim-python-pep8-indent'
    Plug 'kballard/vim-fish'
    Plug 'lambdatoast/elm.vim'
    Plug 'othree/yajs.vim'
    Plug 'othree/es.next.syntax.vim'
    Plug 'lambdatoast/elm.vim'
    Plug 'othree/html5.vim'
    Plug 'plasticboy/vim-markdown'
    Plug 'raichoo/purescript-vim'
    Plug 'rust-lang/rust.vim'
        let g:rust_fold = 1
        let g:rustfmt_autosave = 1
    Plug 'tpope/vim-git'
    Plug 'vimoutliner/vimoutliner'
    Plug 'yosssi/vim-ace'
    Plug 'isobit/vim-caddyfile'
    Plug 'nginx/nginx', { 'rtp': 'contrib/vim' }
    Plug 'nathangrigg/vim-beancount'
    Plug 'LnL7/vim-nix'

    " == Still Evaluating ==

    " -- Miscellaneous --

    Plug 'junegunn/rainbow_parentheses.vim'
        au FileType lisp,clojure,scheme RainbowParentheses
    Plug 'simnalamburt/vim-mundo'
        nnoremap <leader>u :MundoToggle<CR>
    Plug 'junegunn/goyo.vim'
    Plug 'chaimleib/vim-renpy'
    Plug 'powerman/vim-plugin-ansiesc'

    " -- File / Filename Searching --

    Plug 'mileszs/ack.vim'
        if executable('rg')
            let g:ackprg = 'rg --vimgrep'
        endif

    Plug 'ctrlpvim/ctrlp.vim'
        if executable('rg')
          set grepprg=rg\ --color=never
          let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
          let g:ctrlp_use_caching = 0
        endif

    " -- Git integration --

    "Plug 'tpope/vim-fugitive'
    "Plug 'gregsexton/gitv'
    "Plug 'airblade/vim-gitgutter'

call plug#end()

" Appearance
syntax on " (Neovim Default)
set background=dark
colorscheme lucius
set ruler
set colorcolumn=81
set nofoldenable
set showcmd
set ttyfast " (Neovim Default)
set listchars=trail:·,precedes:«,extends:»,nbsp:_,tab:▸· " More: ⌇ ► ▸ ❯ ⇥
set list

" Searching
set hlsearch " (Neovim Default)
set incsearch " (Neovim Default)
set ignorecase
set smartcase

" Behavior
if filereadable($VIMRUNTIME . "/macros/matchit.vim")
    source $VIMRUNTIME/macros/matchit.vim
endif
set backspace=indent,eol,start " (Neovim Default)
set mouse=a "Enables the mouse in terminals (Neovim Default)
set completeopt+=longest
set clipboard=unnamedplus
set wildmode=longest:full,full

" Editing Defaults
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=80
set smarttab " (Neovim Default)
set expandtab
set copyindent
set smartindent
inoremap # X<C-H>#

" File Globbing
set wildignore+=*.py[co]
set wildignore+=*.sw[po]
set wildignore+=.DS_Store
set wildignore+=[Tt]humbs.db
set wildignore+=*.6
set wildignore+=node_modules/*

" Misc
au FileType markdown,text setlocal spell textwidth=0 linebreak
au FileType markdown,text nnoremap j gj
au FileType markdown,text nnoremap gj j
au FileType markdown,text nnoremap k gk
au FileType markdown,text nnoremap gk k
au FileType markdown,text nnoremap $ g$
au FileType markdown,text nnoremap g$ $
au FileType markdown,text nnoremap ^ g^
au FileType markdown,text nnoremap g^ ^
au FileType markdown,text nnoremap 0 g0
au FileType markdown,text nnoremap g0 0
au FileType mail setlocal formatoptions+=aw textwidth=72 colorcolumn=+1 spell nomodeline
au FileType votl,go,make setlocal nolist
au FileType gitcommit setlocal colorcolumn+=51
au FileType javascript setlocal foldmethod=syntax foldlevelstart=1 |
  \ syntax region foldBraces start=/{/ end=/}/ transparent fold keepend extend
au FileType rust compiler cargo
au BufRead,BufNewFile Cargo.toml,Cargo.lock compiler cargo
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
set backupcopy=yes
