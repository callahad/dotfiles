--[[ Aliases ]]
local opt = vim.opt

--[[ Global Options ]]
opt.mouse = 'a' -- Use the mouse in all contexts
opt.clipboard = 'unnamedplus' -- Use the system clipboard automatically

--[[ Appearance ]]
opt.colorcolumn = '81'
opt.list = true
opt.listchars = {
    trail = '·',
    precedes = '«',
    extends = '»',
    nbsp = '_',
    tab = '⇥·',
}

-- Terminal.app on macOS doesn't support 24 bit color. Others do.
opt.termguicolors = (vim.env.TERM_PROGRAM ~= 'Apple_Terminal')

--[[ Searching ]]
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'nosplit' -- Preview effect of s/foo/bar interactively

-- Use \v (verymagic) regex syntax for interactive searches
vim.cmd('nnoremap / /\\v')
vim.cmd('vnoremap / /\\v')
vim.cmd('cnoremap %s/ %s/\\v')

--[[ Editing ]]
opt.tabstop = 4
opt.shiftwidth = 0 -- Follows opt.tabstop
opt.textwidth = 80
opt.expandtab = true
opt.copyindent = true

--[[ Behavior ]]
opt.completeopt:append('longest')
opt.wildmode = { 'longest:full', 'full' }
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--[[ Quirks ]]
-- File watchers like inotify can lose track of files modified by Vim.
-- Work around this by directly overwriting the original file when saving.
-- https://vi.stackexchange.com/questions/25030/
opt.backupcopy = 'yes'

--[[ Plugins ]]
-- Bootstrap Packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Install Plugins
require('packer').startup(function(use)
    -- Prevent Packer from uninstalling itself
    use 'wbthomason/packer.nvim'

    -- Colorschemes
    use 'sjl/badwolf'
    use 'morhetz/gruvbox'
        vim.g.gruvbox_italic = 1
        vim.g.gruvbox_contrast_dark = 'hard'
    use 'w0ng/vim-hybrid'
    use 'nanotech/jellybeans.vim'
        vim.g.jellybeans_use_term_italics = 1
    use 'jonathanfilip/vim-lucius'
        vim.g.lucius_contrast = 'low'
        vim.g.lucius_contrast_bg = 'high'
    use 'KeitaNakamura/neodark.vim'
        vim.g['neodark#use_256color'] = 1
        vim.g['neodark#terminal_transparent'] = 1
    use 'junegunn/seoul256.vim'
        vim.g.seoul256_background = 234
    use 'deu/vim-xoria256mod'

    -- Editing
    use 'editorconfig/editorconfig-vim'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'

    -- Gitsigns: Slightly cleaner alternative to gitgutter
    use {
        'lewis6991/gitsigns.nvim',
         requires = 'nvim-lua/plenary.nvim',
         config = function() require('gitsigns').setup() end
    }

    -- Tree Sitter: Fault-tolerant parser / syntax highlighter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = 'maintained',
                highlight = { enable = true },
            }
        end
    }

    -- Telescope: Fuzzy find everything
    use {
        'nvim-telescope/telescope.nvim',
         requires = {
             'nvim-lua/plenary.nvim',
             { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
         },
         config = function()
             -- Use the fzf extension for better result ordering
             require('telescope').load_extension('fzf')

             vim.cmd[[
                nnoremap <Leader>ff <cmd>Telescope find_files<cr>
                nnoremap <Leader>fF <cmd>Telescope find_files hidden=true<cr>
                nnoremap <Leader>fg <cmd>Telescope live_grep<cr>
                nnoremap <Leader>fb <cmd>Telescope buffers<cr>
                nnoremap <Leader>fh <cmd>Telescope help_tags<cr>
             ]]
         end
    }

    -- Sync plugins if Packer was just installed for the first time
    if packer_bootstrap then
        require('packer').sync()
    end
end)

vim.cmd('colorscheme gruvbox')
