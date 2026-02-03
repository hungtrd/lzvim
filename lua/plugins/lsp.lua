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
        -- Frontend
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "markdownlint",
        "html-lsp",
        -- "htmx-lsp",
        -- Golang
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
        -- markdown
        "prettier",
        "markdownlint-cli2",
        "markdown-toc",
        -- nix
        "nixpkgs-fmt",
        -- "nixfmt",
        -- "nil",
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
          filetype = { "html", "templ" },
        },
        tailwindcss = {
          filetype = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "templ" },
          init_options = { userLanguages = { templ = "html" } },
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                LazyVim.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                LazyVim.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              LazyVim.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              LazyVim.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              LazyVim.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                LazyVim.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
        jdtls = {},
        -- nil_ls = {},
      },
      setup = {
        gopls = function(_, opts) end,
        templ = function(_, opts) end,
        html_lsp = function(_, opts) end,
        htmx_lsp = function(_, opts) end,
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable tsserver
          return true
        end,
        vtsls = function(_, opts) end,
        jdtls = function()
          return true -- avoid duplicate servers
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
