return {
  -- tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "lua-language-server",
        "shellcheck",
        "shfmt",
        -- Frontend (tailwind, html, css - không có extra)
        "tailwindcss-language-server",
        "css-lsp",
        "html-lsp",
        -- Golang (gopls/gofumpt/goimports/golangci-lint/delve do lang.go extra lo)
        "golangci-lint-langserver",
        "templ",
        "iferr",
        -- proto
        "buf-language-server",
      })
    end,
  },
  {
    -- The lang.go extra adds `golangcilint` to nvim-lint, but this config already
    -- runs golangci-lint through `golangci_lint_ls` (see lsp/golangci_lint_ls.lua).
    -- Running both duplicates the work and the nvim-lint invocation fails here.
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft.go = nil
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
        exclude = {}, -- filetypes for which you don't want to enable inlay hints
      },
      servers = {
        -- gopls base config comes from the lang.go extra
        gopls = {
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
        },
        -- golangci_lint_ls config lives in ~/.config/nvim/lsp/golangci_lint_ls.lua
        golangci_lint_ls = {},
        html = {
          filetypes = { "html", "templ" },
        },
        tailwindcss = {
          filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "templ" },
          init_options = { userLanguages = { templ = "html" } },
        },
        -- tsp_server root_markers overridden in ~/.config/nvim/lsp/tsp_server.lua
        tsp_server = {},
      },
    },
  },
}
