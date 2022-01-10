--[[ Aliases ]]
local cmd = vim.cmd
local opt = vim.opt

--[[ Global Options ]]
opt.mouse = 'a' -- Use the mouse in all contexts
opt.clipboard = 'unnamedplus' -- Use the system clipboard automatically

--[[ Appearance ]]
opt.colorcolumn = '81'
opt.list = true
opt.listchars = {
    -- ⌇ ► ▸ ❯ · ⇥
    trail = '·',
    precedes = '«',
    extends = '»',
    nbsp = '_',
    tab = '⇥·',
}

--[[ Searching ]]
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'nosplit' -- Preview effect of s/foo/bar interactively

-- Use \v (verymagic) regex syntax for interactive searches
cmd('nnoremap / /\\v')
cmd('vnoremap / /\\v')
cmd('cnoremap %s/ %s/\\v')

--[[ Editing ]]
opt.tabstop = 4
opt.shiftwidth = 0 -- follow opt.tabstop
opt.textwidth = 80
opt.expandtab = true
opt.copyindent = true

--[[ Quirks ]]
-- File watchers like inotify can lose track of files modified by Vim.
-- Work around this by directly overwriting the original file when saving.
-- https://vi.stackexchange.com/questions/25030/
opt.backupcopy = 'yes'
