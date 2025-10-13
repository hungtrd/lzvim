return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "cmake",
        "gitignore",
        "graphql",
        "http",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        -- shell
        "bash",
        "fish",
        "nix",
        -- vim
        "vim",
        "lua",
        -- config
        "yaml",
        "json",
        -- frontend
        "typescript",
        "tsx",
        "javascript",
        "html",
        "css",
        "scss",
        -- backend
        "rust",
        "python",
        "sql",
        "go",
        "templ",
      },
    },
    -- config = function(_, opts)
    --   require("nvim-treesitter.configs").setup(opts)
    --
    --   -- MDX
    --   vim.filetype.add({
    --     extension = {
    --       mdx = "mdx",
    --     },
    --   })
    --   vim.treesitter.language.register("markdown", "mdx")
    -- end,
  },
}
