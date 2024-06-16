print("Init file loaded")

vim.cmd('language en_US.UTF-8')

-- Install lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
-- or                              , branch = '0.1.x',
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{ "vim-airline/vim-airline", name = "vim-airline" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- LSP
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},

    -- Better list UI
    {'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = { 'nvim-lua/plenary.nvim' }},

    -- Fast file switch
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    }
})

-- Theme setup
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true
})
vim.opt.termguicolors = true
vim.cmd.colorscheme "catppuccin"

-- Treesitter setup
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "rust", "python" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enabled = true
    }
})

-- LSP setup
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keybindings',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  end
})

local lspconfig = require('lspconfig')
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
  },
  handlers = {
    function(server)
      lspconfig[server].setup({
        capabilities = lsp_capabilities,
      })
    end,
    lua_ls = function()
      lspconfig.lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = {'vim'}
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              }
            }
          }
        }
      })
    end,
  }
})

require('lspconfig').ruff.setup {}

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    -- {name = 'buffer', keyword_length = 3},
    -- {name = 'luasnip', keyword_length = 2},
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
  }),
  window = {
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-- Harpoon setup
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.autoindent = true

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Multiline move
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv'")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv'")

-- Split window
vim.keymap.set("n", "<leader>wv", "<C-w><C-s>")
vim.keymap.set("n", "<leader>w-", "<C-w><C-s>")
vim.keymap.set("n", "<leader>wh", "<C-w><C-v>")
vim.keymap.set("n", "<leader>w|", "<C-w><C-v>")

-- Move between windows
vim.keymap.set("n", "H", "<C-w><C-h>")
vim.keymap.set("n", "J", "<C-w><C-j>")
vim.keymap.set("n", "K", "<C-w><C-k>")
vim.keymap.set("n", "L", "<C-w><C-l>")

-- Moving half-screens will keep cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Searching will keep cursor in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Leader p will paste into a marked section without replacing buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Leader y or d will yank to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Rename the word on the cursor
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ph', builtin.help_tags, {})

vim.g.airline_theme = 'dark'
vim.g.airline_powerline_fonts = 1
vim.g.airline_left_sep = ""
vim.g.airline_left_alt_sep = ""
vim.g.airline_right_sep = ""
vim.g.airline_right_alt_sep = ""
vim.g.airline_branch_symbol = ""
vim.g.airline_readonly_symbol = ""
vim.g.airline_modified_symbol = "●"
