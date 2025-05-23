-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = ";"

vim.filetype.add({
  extension = {
    templ = "templ",
    psql = "sql",
  },
})

vim.g.lazyvim_picker = "telescope"
