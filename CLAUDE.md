# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on [LazyVim](https://lazyvim.github.io/) — a Neovim config framework using `lazy.nvim` as the plugin manager. The config is structured as overrides and extensions on top of LazyVim defaults.

## Code Style

Lua files are formatted with **StyLua**:
- Indent: 2 spaces
- Column width: 120

Run formatting: `stylua lua/ lsp/` (the binary lives in Mason: `~/.local/share/nvim/mason/bin/stylua`)

**Requires Neovim >= 0.12** (LazyVim v16 + the `nvim-treesitter` `main` branch, which needs the `tree-sitter` CLI).

## Architecture

### Entry Point
`init.lua` → `lua/config/lazy.lua` (bootstraps lazy.nvim and loads all plugins)

### Config Layer (`lua/config/`)
Loaded automatically by LazyVim in order:
- `options.lua` — Vim options; sets `mapleader = ";"` and `lazyvim_picker = "snacks"`; registers `.templ` and `.psql` filetypes
- `keymaps.lua` — Custom keymaps on top of LazyVim defaults
- `autocmds.lua` — Empty; `.templ` formatting is handled by conform (see `lua/plugins/conform.lua`)
- `lazy.lua` — Plugin manager setup; sets colorscheme to `nordfox`

### Native LSP Configs (`lsp/`)
Per-server files consumed by Neovim's built-in `vim.lsp.config` (0.11+). Prefer this over
`require("lspconfig")`, whose framework layer is deprecated and slated for removal:
- `tsp_server.lua` — TypeSpec; `root_markers = { "tspconfig.yaml" }` only (not `.git`), so each
  project under `tsp/` gets its own LSP instance
- `golangci_lint_ls.lua` — golangci-lint language server; `root_markers = { "go.mod", ".git" }`

### Plugin Overrides (`lua/plugins/`)
Each file returns a lazy.nvim plugin spec that extends or overrides LazyVim defaults:

- `lsp.lua` — Only what the `lang.go` extra does *not* provide: `<leader>td` gopls keymap,
  html/tailwind `templ` support, disabling the duplicate `golangcilint` nvim-lint run
  (`golangci_lint_ls` already covers it), and Mason installs for frontend/shell/proto tools
- `picker.lua` — snacks.picker opts (`telescope` layout preset) and the custom `;`-prefixed keymaps
- `conform.lua` — Only `yaml` and `templ`; markdown comes from `lang.markdown`, Go from `lang.go`.
  Must stay a **table** (not a function) so it merges into upstream defaults instead of replacing them
- `treesitter.lua` — Additional parsers: Go, templ, TypeScript/TSX, Rust, Python, SQL, Nix, fish, etc.
- `editor.lua` — flash.nvim remapped to `m`/`M` (default `s`/`S` disabled); bufferline in tabs mode;
  snacks.notifier timeout
- `ui.lua` — snacks.dashboard with custom ASCII logo
- `colorscheme.lua` — Color scheme configuration
- `markdown.lua` — markdownlint-cli2 config path

### LazyVim Extras (`lazyvim.json`)
Enabled extras:
- `ai.copilot` — GitHub Copilot
- `dap.core`, `dap.nlua` — Debug Adapter Protocol
- `lang.go` — gopls, delve, nvim-dap-go, neotest-golang, goimports/gofumpt
- `lang.markdown` — Markdown language support
- `lang.java` — Java via nvim-jdtls
- `lang.typescript` — TypeScript support
- `test.core` — neotest framework

`editor.snacks_picker` is imported implicitly by `vim.g.lazyvim_picker = "snacks"`, so it is not
listed in `lazyvim.json`. Leave `install_version` at `7` — bumping it to `8` flips the default
explorer from neo-tree to snacks.

## Key Customizations

- **Leader key**: `;` (not the LazyVim default `<space>`)
- **Flash jump**: `m`/`M` instead of `s`/`S`
- **Tab navigation**: `<Tab>`/`<S-Tab>` cycle bufferline tabs
- **Window splits**: `ss` (horizontal), `sv` (vertical); navigate with `sh`/`sj`/`sk`/`sl`
- **Go error blocks**: `<Leader>if` triggers `:IfErr`
- **Go debug**: `<leader>td` runs `dap-go` debug nearest test
- **Picker**: `;f` files, `;r` grep, `\\` buffers, `;h` help, `;;` resume, `;s` treesitter symbols,
  `sf` explorer at the buffer's directory

### Leader-key collisions

`mapleader` is `;`, so a mapping like `;e` *is* `<leader>e`. Single-letter maps under `;` compete with
LazyVim's groups, and the group generally wins — `;e` resolves to neo-tree and `;t` to the test group.
Before adding a `;<letter>` mapping, check what is free:

```vim
:lua vim.print(vim.tbl_map(function(m) return m.lhs end, vim.api.nvim_get_keymap("n")))
```

Currently free: `a j k m p v y z` (`h` is taken by the help picker). `;f`, `;r` and `;s` are claimed by this config and win over their
LazyVim groups, at the cost of a `timeoutlen` delay on `;f*`, `;r*` and `;s*`.

## Adding Plugins

Add a new file in `lua/plugins/` returning a lazy.nvim spec, or add to an existing file. Plugin specs follow the [lazy.nvim spec format](https://lazy.folke.io/spec). To override a LazyVim plugin, use the same plugin name/repo.
