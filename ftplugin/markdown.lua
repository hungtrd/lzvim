-- LazyVim sets conceallevel=2 globally, which hides `**` and backticks via treesitter even
-- when render-markdown is off. Since render-markdown starts disabled (see
-- lua/plugins/markdown.lua), open markdown as raw text; `<leader>um` raises it back to 3.
vim.opt_local.conceallevel = 0
