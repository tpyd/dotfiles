-- TODO deleting the nvim-data folder causes a lazy.nvim error when
-- reinstalling all plugins. Specifically for the colortheme plugin.

-- Set the language to english. Neovim will by 
-- default use the system language set by the OS.
vim.env.LANG = "en_US"

-- Set the leader key to be space
vim.g.mapleader = " "

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
vim.opt.colorcolumn = "88"

-- Disable highlighting text that matches the search. The 
-- hightlight lingers long after the search if enabled.
-- TODO create autocommand so that text is highlighted only when searching is
-- performed.
vim.opt.hlsearch = false

-- Signcolumn is the column to the left of the line numbers, which shows 
-- information like linter warnings/errors, breakpoints, git changes etc.
vim.opt.signcolumn = "yes"

-- Hotkey for returning to the file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Setup lazy.nvim, a plugin manager for neovim.
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

-- Plugins
local plugins = {
    -- Colorscheme plugin. Needs to be loaded as fast as possible.
    { 
        "catppuccin/nvim",
        name = "catppuccin",
        tag = "v1.9.0",
        lazy = false,
        priority = 1000
    },

    -- Custom colorcolumn. Also known as ruler. Much 
    -- thinner version and with a suble color.
    { 
        "lukas-reineke/virt-column.nvim", 
        tag = "v2.0.2"
    },

    -- Telescope for efficient searching across files.
    -- Requires Plenary which is a collection of Lua function.
    {
        "nvim-telescope/telescope.nvim", 
        tag = "0.1.8",
        dependencies = {
            {
                "nvim-lua/plenary.nvim",
                tag = "v0.1.4"
            }
        }
    },

    -- Lspconfig for easier lsp configuration
    {
        "neovim/nvim-lspconfig",
        tag = "v1.0.0"
    },

    -- Mason for downloading LSPs
    {
        "williamboman/mason.nvim",
        tag = "v1.10.0"
    },

    -- Mason lspconfig to integrate with nvim-lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        tag = "v1.31.0"
    },

    -- Autocomplete framework
    {
        "hrsh7th/nvim-cmp",
        commit = "b555203"
    },

    -- Autocomplete LSP support
    {
        "hrsh7th/cmp-nvim-lsp",
        commit = "99290b3"
    }
}

-- Install plugins
require("lazy").setup({
    spec = plugins,

    -- Don't check for plugin updates
    checker = { enabled = false },
})

-- Configure catppuccin
require("catppuccin").setup({
    transparent_background = true
})

-- Configure virt-column with a more suble char & color
require("virt-column").setup({
    char = { "┆" },
    highlight = { "LineNr" } 
})

-- Set the colorscheme
vim.cmd.colorscheme "catppuccin"

-- Configure key mappings
local builtin = require("telescope.builtin")

-- Fuzzy search all files 
vim.keymap.set("n", "<leader>pf", builtin.find_files)

-- Live grep all files
vim.keymap.set("n", "<leader>pg", builtin.live_grep)

-- Set up LSP
-- TODO lspconfig fails before mason has time to install any LSP.
-- TODO after mason has installed an LSP, a restart is required for the LSP to start.
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "ruff",
        "rust_analyzer"
    },
    automatic_installation = true
})

-- TODO configure lua lsp so it recognizes nvim variables
require("lspconfig").lua_ls.setup({})
require("lspconfig").ruff.setup({})

require("lspconfig").rust_analyzer.setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities()
})

-- Autocomplete setup
local cmp = require("cmp")

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort()
    },
    sources = {
        { name = "nvim_lsp" },
    },
})
