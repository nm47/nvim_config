-- Set line numbers
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true

-- Persistent undo - allows undoing changes after closing and reopening files
local undodir = vim.fn.stdpath("config") .. "/undo" -- Change the path as needed
vim.opt.undodir = undodir
vim.opt.undofile = true -- Enable undofile

-- Ensure the directory for undofiles exists
if not vim.loop.fs_stat(undodir) then
  vim.loop.fs_mkdir(undodir, 511) -- 511 decimal is 0777 octal
end

-- Path for swap files
local swapdir = vim.fn.stdpath("config") .. "/swap"

-- Ensure the swap directory exists
if not vim.loop.fs_stat(swapdir) then
  vim.loop.fs_mkdir(swapdir, 511) -- 511 decimal is 0777 octal
end

-- Set Neovim to store swap files in the specified directory
vim.opt.directory = swapdir

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/LazyVim/LazyVim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  { "Mofiqul/vscode.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
      "neovim/nvim-lspconfig",
    config = function()
      require('lspconfig').clangd.setup{}
      require('lspconfig').pyright.setup{} -- or pylsp if you prefer
    end
  },
})

-- To enable the colorscheme and settings for 'indent-blankline.nvim' plugin
local highlight = {
    "CursorColumn",
    "Whitespace",
}
require("ibl").setup {
    indent = { highlight = highlight, char = '┊' },
        whitespace = {
        remove_blankline_trail = false,
    },
}

vim.o.background = 'dark'
local c = require('vscode.colors').get_colors()
require('vscode').setup({
    -- Alternatively set style in setup
    -- style = 'light'

    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#FADA5E',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})
require('vscode').load()

-- autoformat cpp + python
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = {"*.cpp", "*.py"},
  callback = function()
    vim.lsp.buf.formatting_sync(nil, 1000)
  end,
})
