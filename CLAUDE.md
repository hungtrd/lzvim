# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on [LazyVim](https://lazyvim.github.io/) — a Neovim config framework using `lazy.nvim` as the plugin manager. The config is structured as overrides and extensions on top of LazyVim defaults.

## Code Style

Lua files are formatted with **StyLua**:
- Indent: 2 spaces
- Column width: 120

Run formatting: `stylua lua/`

## Architecture

### Entry Point
`init.lua` → `lua/config/lazy.lua` (bootstraps lazy.nvim and loads all plugins)

### Config Layer (`lua/config/`)
Loaded automatically by LazyVim in order:
- `options.lua` — Vim options; sets `mapleader = ";"` and `lazyvim_picker = "telescope"`; registers `.templ` and `.psql` filetypes
- `keymaps.lua` — Custom keymaps on top of LazyVim defaults
- `autocmds.lua` — Auto-formats `.templ` files with `templ fmt` on save
- `lazy.lua` — Plugin manager setup; sets colorscheme to `nordfox`

### Plugin Overrides (`lua/plugins/`)
Each file returns a lazy.nvim plugin spec that extends or overrides LazyVim defaults:

- `lsp.lua` — LSP server configs: gopls (Go), golangci-lint-langserver, html/tailwind (with templ support); Mason tool installs for Go, frontend, shell, proto, nix
- `conform.lua` — Formatter config: markdown uses prettier+markdownlint-cli2+markdown-toc; yaml uses prettier; Go uses goimports+gofumpt (in lsp.lua)
- `treesitter.lua` — Additional parsers: Go, templ, TypeScript/TSX, Rust, Python, SQL, Nix, fish, etc.
- `editor.lua` — flash.nvim remapped to `m`/`M` (default `s`/`S` disabled); bufferline in tabs mode; git.nvim for blame/browse
- `ui.lua` — dashboard-nvim with custom ASCII logo
- `dap.lua` — nvim-dap-go for Go debug adapter
- `test.lua` — neotest-golang adapter
- `colorscheme.lua` — Color scheme configuration
- `telescope.lua` — Telescope overrides
- `markdown.lua` — Markdown-related plugin config
- `trouble.lua` — Trouble.nvim config
- `ai.lua` — (empty, placeholder for AI plugins)

### LazyVim Extras (`lazyvim.json`)
Enabled extras:
- `ai.copilot` — GitHub Copilot
- `dap` — Debug Adapter Protocol
- `lang.markdown` — Markdown language support
- `lang.java` — Java via nvim-jdtls
- `lang.typescript` — TypeScript support
- `test.core` — neotest framework

## Key Customizations

- **Leader key**: `;` (not the LazyVim default `<space>`)
- **Flash jump**: `m`/`M` instead of `s`/`S`
- **Tab navigation**: `<Tab>`/`<S-Tab>` cycle bufferline tabs
- **Window splits**: `ss` (horizontal), `sv` (vertical); navigate with `sh`/`sj`/`sk`/`sl`
- **Go error blocks**: `<Leader>if` triggers `:IfErr`
- **Go debug**: `<leader>td` runs `dap-go` debug nearest test

## Adding Plugins

Add a new file in `lua/plugins/` returning a lazy.nvim spec, or add to an existing file. Plugin specs follow the [lazy.nvim spec format](https://lazy.folke.io/spec). To override a LazyVim plugin, use the same plugin name/repo.
