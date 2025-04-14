vim.env.LANG = "en_US"

vim.g.mapleader = " "

vim.diagnostic.config({ virtual_text = true })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

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
                    "gitcommit",
                    "lua",
                    "markdown",
                    "query",
                    "rust",
                    "toml"
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
    },
    {
        "neovim/nvim-lspconfig"
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer"
                }
            })
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({})
        end
    },
    {
        "ibhagwan/fzf-lua",
        config = function()
            local fzf = require("fzf-lua")

            vim.keymap.set("n", "<leader>pf", fzf.files)
            vim.keymap.set("n", "<leader>pg", fzf.live_grep)
            vim.keymap.set("n", "<leader>pb", fzf.buffers)
            vim.keymap.set("n", "<leader>pm", fzf.marks)
        end
    }
})

vim.lsp.config("lua_ls", {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path.."/.luarc.json") or vim.uv.fs_stat(path.."/.luarc.jsonc")) then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                version = "LuaJIT"
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
    settings = {
        Lua = {}
    }
})

vim.lsp.enable({
    "lua_ls",
    "rust_analyzer"
})

