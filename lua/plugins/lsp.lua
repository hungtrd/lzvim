return {
  -- tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "lua-language-server",
        "shellcheck",
        "shfmt",
        -- Frontend (tailwind, html, css - không có extra)
        "tailwindcss-language-server",
        "css-lsp",
        "html-lsp",
        -- Golang (không dùng lang.go extra)
        "gopls",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver",
        "templ",
        "iferr",
        "delve",
        "go-debug-adapter",
        -- proto
        "buf-language-server",
        -- nix
        "nixpkgs-fmt",
      })
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
        gopls = {
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = false,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        golangci_lint_ls = {
          cmd = { "golangci-lint-langserver" },
          filetypes = { "go" },
          root_dir = require("lspconfig.util").root_pattern(".git", "go.mod"),
          init_options = {
            command = { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false" },
          },
        },
        html = {
          filetypes = { "html", "templ" },
        },
        tailwindcss = {
          filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "templ" },
          init_options = { userLanguages = { templ = "html" } },
        },
      },
      setup = {
        -- jdtls handled by lang.java extra (nvim-jdtls plugin)
        jdtls = function()
          return true
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
        end,
      },
    },
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.gofumpt,
      })
    end,
  },
}
