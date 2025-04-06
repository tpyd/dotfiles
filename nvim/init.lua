vim.env.LANG = "en_US"

vim.g.mapleader = " "

vim.diagnostic.config({ virtual_text = true })

vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 16
vim.opt.shiftwidth = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.virtualedit = "block"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            require("gruvbox").setup({
                transparent_mode = true
            })
            vim.cmd.colorscheme("gruvbox")
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "query",
                    "lua",
                    "rust",
                    "python",
                    "c_sharp",
                    "toml",
                    "markdown",
                    "xml"
                },
                auto_install = true,
                highlight = {
                    enable = true
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Leader>ss",
                        node_incremental = "<Leader>si",
                        scope_incremental = "<Leader>sc",
                        node_decremental = "<Leader>sd"
                    }
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    }
                }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end
    }
})

vim.lsp.config["luals"] = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { "init.lua" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            }
        }
    }
}

-- TODO rust-analyzer doesn't work
vim.lsp.config("rust-analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
    before_init = function(init_params, config)
        if config.settings and config.settings['rust-analyzer'] then
            init_params.initializationOptions = config.settings['rust-analyzer']
        end
    end,
})

vim.lsp.enable({
    "luals",
    "rust-analyzer"
})

