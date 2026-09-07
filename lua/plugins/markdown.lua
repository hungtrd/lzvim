return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml",
            "--",
          },
        },
      },
    },
  },
  {
    -- `<leader>um` only toggles this plugin's decorations. Concealing `**` and backticks is
    -- treesitter plus 'conceallevel', which LazyVim sets to 2 — so on disable the plugin was
    -- restoring 2, not 0, and inline markup stayed hidden. Restore 0 instead so one keymap
    -- turns off both. `<leader>uc` still toggles 'conceallevel' on its own.
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      -- Start markdown files as raw text; press `<leader>um` when a rendered view is wanted.
      enabled = false,
      win_options = {
        conceallevel = { default = 0, rendered = 3 },
      },
    },
  },
}
