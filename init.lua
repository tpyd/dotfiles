-- Set the language to english. Neovim will by 
-- default use the system language set by the OS.
vim.env.LANG = "en_US"

-- TODO If you have an unaligned line, and you tab in front to try 
-- and align, the line will not be aligned unless the cursor is at 
-- the first character of the line.

-- Tabstop will decide how many spaces a <Tab> press will make. 
vim.opt.tabstop = 4

-- Shiftwidth is how much to shift lines when using << or >> commands.
vim.opt.shiftwidth = 4

-- Expand tabs into spaces, that way files will only contain spaces.
vim.opt.expandtab = true

-- How many lines to keep between the current 
-- line and the top or bottom of the screen.
vim.opt.scrolloff = 8

-- Show relative line number, so commands like yanking, 
-- deleting etc. is easier to do on multiple lines.
vim.opt.relativenumber = true

-- Show the line number instead of the relative 
-- line number on the line of the cursor.
vim.opt.number = true

-- Search will be case-insensitive by default, unless it contains 
-- uppercase letters, then it will be case-sensitive.
vim.opt.smartcase = true

-- Yaking and putting will go to the system clipboard.
vim.opt.clipboard = "unnamedplus"

-- Visual guide at a given column to avoid long lines.
-- TODO make it into a line instead of a block 
-- if possible after colorscheme is set. Also needs to be 81.
vim.opt.colorcolumn = "80"

-- Disable highlighting text that matches the search. The 
-- hightlight lingers long after the search if enabled.
-- TODO try set autocommand so that text is highlighted only when searching is
-- performed.
vim.opt.hlsearch = false

-- Signcolumn is the column to the left of the line numbers, which shows 
-- information like linter warnings/errors, breakpoints, git changes etc.
vim.opt.signcolumn = "yes"

-- Set the leader key to be space
vim.g.mapleader = " "

-- Hotkey for returning to the file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Setup lazy.nvim, a package manager for neovim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Only install if it's not already installed.
-- Will be installed into the neovim data directory.
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ 
        "git", 
        "clone", 
        "--filter=blob:none", 
        "--branch=v11.14.1",
        "--single-branch",
        "--depth=1",
        lazyrepo, 
        lazypath 
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "ErrorMsg" },
            { "\nPress any key to exit..." },
        }, true, {})

        vim.fn.getchar()

        os.exit(1)
    end
end

-- Add lazy.nvim to the runtime path
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    -- Plugins
    spec = {
        -- Colorscheme plugin
        -- TODO pin to a tag, check if we can limit the clone
        { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },

    -- automatically check for plugin updates
    checker = { enabled = true },
})

-- Set the colorscheme
vim.cmd.colorscheme "catppuccin"

