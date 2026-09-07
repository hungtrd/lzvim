# 💤 Neovim

Personal [Neovim](https://neovim.io) configuration built on [LazyVim](https://lazyvim.github.io),
tuned for Go, Rust, TypeSpec and TypeScript.

## Requirements

### Core — always needed

|                                                  | Minimum  | Why                                                 |
| ------------------------------------------------ | -------- | --------------------------------------------------- |
| [Neovim](https://neovim.io)                      | **0.12** | LazyVim v16 and the `nvim-treesitter` `main` branch |
| `git`, `curl`                                    | —        | lazy.nvim clones plugins; Mason downloads packages  |
| C compiler + `make`                              | —        | tree-sitter compiles each parser to a `.so`         |
| `unzip`, `tar`, `gzip`, `bash`                   | —        | Mason unpacks archives                              |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | —        | `;r` and `;sg` grep, plus grug-far's default engine |
| A [Nerd Font](https://www.nerdfonts.com/)        | —        | icons                                               |

### Runtimes — required even if you never write that language

This is the part that trips people up. Mason builds **17 of its 28 packages from source**, so
`go` and `node` are hard requirements for this config, not per-language extras:

|                | Minimum              | Mason builds with it                                                                                                                                   |
| -------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Go**         | 1.21+                | gopls, delve, gofumpt, goimports, iferr, golangci-lint-langserver, buf-language-server                                                                 |
| **Node + npm** | node **22+**, npm 7+ | vtsls, typescript-language-server, tsp-server, prettier, tailwindcss-language-server, css-lsp, html-lsp, markdownlint, markdownlint-cli2, markdown-toc |

`GOTOOLCHAIN=auto` (the default since Go 1.21) pulls a newer toolchain automatically when a
tool needs one, so there is no need to chase the latest Go release. The Node 22 floor comes
from Copilot, not Mason — Mason itself only needs Node 14+.

The remaining 11 packages (stylua, shellcheck, shfmt, taplo, codelldb, lua-language-server,
marksman, golangci-lint, js-debug-adapter, tree-sitter-cli, templ) ship as prebuilt binaries.
**Do not install those by hand** — Mason fetches them, including the `tree-sitter` CLI.

### Per-language — only if you use it

| Language             | Needs                                               | Notes                                                                                                                                                                                                                                              |
| -------------------- | --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Rust                 | `rustup`, then `rustup component add rust-analyzer` | rustaceanvim expects `rust-analyzer` on `PATH` and does **not** get it from Mason. `~/.cargo/bin/rust-analyzer` exists as a rustup shim even when the component is missing, so `command -v` proves nothing — verify with `rust-analyzer --version` |
| Go, templ            | `go` — see above                                    | the `templ` binary comes from Mason; no `go install` needed                                                                                                                                                                                        |
| TypeScript, TypeSpec | `node` — see above                                  |                                                                                                                                                                                                                                                    |

### Optional — what you lose without it

|                                          | Missing it means                                                                                             |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| [`fd`](https://github.com/sharkdp/fd)    | `;f` and `sf` fall back to ripgrep, then `find`. Debian names the binary `fdfind`; the picker accepts either |
| `lazygit`                                | no `;gg` / `;gG`                                                                                             |
| [`gh`](https://cli.github.com)           | no GitHub pickers: `;gi` `;gI` `;gp` `;gP`                                                                   |
| [`ast-grep`](https://ast-grep.github.io) | grug-far (`;sr`) loses its structural engine; the ripgrep engine still works                                 |

### Install

#### macOS

```sh
xcode-select --install     # C compiler, make, git — skip if already present
brew install neovim ripgrep fd lazygit gh node go rustup ast-grep
brew install --cask font-jetbrains-mono-nerd-font
rustup default stable
```

`curl`, `unzip`, `tar` and `gzip` ship with macOS.

#### Arch Linux

```sh
sudo pacman -S --needed neovim git curl unzip base-devel \
  ripgrep fd lazygit github-cli nodejs npm go rustup \
  ttf-jetbrains-mono-nerd
rustup default stable
# ast-grep lives in the AUR:  paru -S ast-grep
```

#### Debian / Ubuntu

```sh
sudo apt install -y build-essential git curl unzip ripgrep fd-find
```

Debian's archives are usually too old for the pieces that matter here — Neovim (needs 0.12),
Go, and Node (needs 22+ for Copilot). Get those from upstream instead:

|           | Where                                                                                              |
| --------- | -------------------------------------------------------------------------------------------------- |
| Neovim    | release tarball or AppImage from [GitHub](https://github.com/neovim/neovim/releases)               |
| Node      | [NodeSource](https://github.com/nodesource/distributions), or a version manager like `fnm` / `nvm` |
| Go        | tarball from [go.dev/dl](https://go.dev/dl/)                                                       |
| `gh`      | [GitHub CLI apt repository](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)           |
| `lazygit` | not packaged — download a [release](https://github.com/jesseduffield/lazygit/releases)             |
| `rustup`  | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh`                                  |

### Then

```sh
git clone <this-repo> ~/.config/nvim
nvim                              # plugins install on first launch
rustup component add rust-analyzer  # only if you write Rust
```

Finish with `:checkhealth`, and on Apple Silicon run the
[code-signing step](#macos-apple-silicon--tree-sitter-parser-crash-fix) below.

## Layout

```text
init.lua              → lua/config/lazy.lua
lua/config/           options, keymaps, lazy.nvim bootstrap
lua/plugins/          plugin overrides (one file per concern)
lsp/                  native vim.lsp.config server definitions
ftplugin/             per-filetype indentation
lazyvim.json          which LazyVim extras are enabled
```

`lsp/` uses Neovim's built-in `vim.lsp.config` rather than the `nvim-lspconfig`
framework layer, which upstream has deprecated and plans to remove.

- `lsp/tsp_server.lua` — TypeSpec. Roots on `tspconfig.yaml` **only** (not `.git`), so
  each project under `tsp/` gets its own server instance.
- `lsp/golangci_lint_ls.lua` — golangci-lint language server.

## Keymaps

Leader is `;`. Everything below is generated from a live session with one buffer open per
supported filetype, so it reflects what is actually bound — LazyVim defaults, plugin maps and
this config's own overrides together.

**Mode**: `n` normal · `x` visual · `o` operator-pending · `i` insert · `s` select ·
`c` command-line · `t` terminal.

**Where** tells you when the mapping exists:

|              |                                                                |
| ------------ | -------------------------------------------------------------- |
| `—`          | global — always available                                      |
| `LSP`        | needs an attached language server                              |
| `treesitter` | needs a parser for the current filetype                        |
| `git repo`   | file must be inside a Git repository                           |
| a filetype   | only in that filetype (`markdown`, `go`, `rust`, `typescript`) |

Press `;?` for the live, buffer-aware list, or `;sk` to search every keymap.

> **Leader collisions.** Because leader is `;`, a mapping like `;e` _is_ `<leader>e`, so
> single-letter maps compete with LazyVim's groups — and the group usually wins. `;f`, `;r`
> and `;s` are claimed by this config and do win, at the cost of a `timeoutlen` delay on
> `;f*`, `;r*` and `;s*`. Free letters: `a j k m p v y z`.

### General

| Key        | Mode | Where | Action                      |
| ---------- | ---- | ----- | --------------------------- |
| `;<Space>` | `n`  | —     | Find Files (Root Dir)       |
| `;;`       | `n`  | —     | Resume Picker               |
| `;.`       | `n`  | —     | Toggle Scratch Buffer       |
| `;/`       | `n`  | —     | Grep (Root Dir)             |
| `;:`       | `n`  | —     | Command History             |
| `;?`       | `n`  | —     | Buffer Keymaps (which-key)  |
| `;E`       | `n`  | —     | Explorer NeoTree (cwd)      |
| `;e`       | `n`  | —     | Explorer NeoTree (Root Dir) |
| `;h`       | `n`  | —     | Help Tags                   |
| `;if`      | `n`  | —     | `:IfErr<CR>`                |
| `;K`       | `n`  | —     | Keywordprg                  |
| `;L`       | `n`  | —     | LazyVim Changelog           |
| `;l`       | `n`  | —     | Lazy                        |
| `;n`       | `n`  | —     | Notification History        |
| `;O`       | `n`  | —     | `O<Esc>^Da`                 |
| `;o`       | `n`  | —     | `o<Esc>^Da`                 |
| `;r`       | `n`  | —     | Grep                        |
| `;S`       | `n`  | —     | Select Scratch Buffer       |

### Find files

| Key   | Mode | Where | Action                      |
| ----- | ---- | ----- | --------------------------- |
| `;f`  | `n`  | —     | Find Files (hidden)         |
| `;fB` | `n`  | —     | Buffers (all)               |
| `;fb` | `n`  | —     | Buffers                     |
| `;fc` | `n`  | —     | Find Config File            |
| `;fE` | `n`  | —     | Explorer NeoTree (cwd)      |
| `;fe` | `n`  | —     | Explorer NeoTree (Root Dir) |
| `;fF` | `n`  | —     | Find Files (cwd)            |
| `;ff` | `n`  | —     | Find Files (Root Dir)       |
| `;fg` | `n`  | —     | Find Files (git-files)      |
| `;fn` | `n`  | —     | New File                    |
| `;fP` | `n`  | —     | Find Plugin File            |
| `;fp` | `n`  | —     | Projects                    |
| `;fR` | `n`  | —     | Recent (cwd)                |
| `;fr` | `n`  | —     | Recent                      |
| `;fT` | `n`  | —     | Terminal (cwd)              |
| `;ft` | `n`  | —     | Terminal (Root Dir)         |

### Search / pickers

| Key   | Mode | Where | Action                              |
| ----- | ---- | ----- | ----------------------------------- |
| `;s`  | `n`  | —     | Treesitter Symbols                  |
| `;s"` | `n`  | —     | Registers                           |
| `;s/` | `n`  | —     | Search History                      |
| `;sa` | `n`  | —     | Autocmds                            |
| `;sB` | `n`  | —     | Grep Open Buffers                   |
| `;sb` | `n`  | —     | Buffer Lines                        |
| `;sC` | `n`  | —     | Commands                            |
| `;sc` | `n`  | —     | Command History                     |
| `;sD` | `n`  | —     | Buffer Diagnostics                  |
| `;sd` | `n`  | —     | Diagnostics                         |
| `;sG` | `n`  | —     | Grep (cwd)                          |
| `;sg` | `n`  | —     | Grep (Root Dir)                     |
| `;sH` | `n`  | —     | Highlights                          |
| `;sh` | `n`  | —     | Help Pages                          |
| `;si` | `n`  | —     | Icons                               |
| `;sj` | `n`  | —     | Jumps                               |
| `;sk` | `n`  | —     | Keymaps                             |
| `;sl` | `n`  | —     | Location List                       |
| `;sM` | `n`  | —     | Man Pages                           |
| `;sm` | `n`  | —     | Marks                               |
| `;sp` | `n`  | —     | Search for Plugin Spec              |
| `;sq` | `n`  | —     | Quickfix List                       |
| `;sR` | `n`  | —     | Resume                              |
| `;sr` | `nx` | —     | Search and Replace                  |
| `;sS` | `n`  | LSP   | LSP Workspace Symbols               |
| `;ss` | `n`  | LSP   | LSP Symbols                         |
| `;sT` | `n`  | —     | Todo/Fix/Fixme                      |
| `;st` | `n`  | —     | Todo                                |
| `;su` | `n`  | —     | Undotree                            |
| `;sW` | `nx` | —     | Visual selection or word (cwd)      |
| `;sw` | `nx` | —     | Visual selection or word (Root Dir) |

### Buffers

| Key      | Mode | Where | Action                      |
| -------- | ---- | ----- | --------------------------- |
| `;,`     | `n`  | —     | Buffers                     |
| `` ;` `` | `n`  | —     | Switch to Other Buffer      |
| `;bb`    | `n`  | —     | Switch to Other Buffer      |
| `;bD`    | `n`  | —     | Delete Buffer and Window    |
| `;bd`    | `n`  | —     | Delete Buffer               |
| `;be`    | `n`  | —     | Buffer Explorer             |
| `;bi`    | `n`  | —     | Delete Invisible Buffers    |
| `;bj`    | `n`  | —     | Pick Buffer                 |
| `;bl`    | `n`  | —     | Delete Buffers to the Left  |
| `;bo`    | `n`  | —     | Delete Other Buffers        |
| `;bP`    | `n`  | —     | Delete Non-Pinned Buffers   |
| `;bp`    | `n`  | —     | Toggle Pin                  |
| `;br`    | `n`  | —     | Delete Buffers to the Right |
| `H`      | `n`  | —     | Prev Buffer                 |
| `L`      | `n`  | —     | Next Buffer                 |

### Tabs

| Key           | Mode | Where | Action           |
| ------------- | ---- | ----- | ---------------- |
| `;<Tab><Tab>` | `n`  | —     | New Tab          |
| `;<Tab>[`     | `n`  | —     | Previous Tab     |
| `;<Tab>]`     | `n`  | —     | Next Tab         |
| `;<Tab>d`     | `n`  | —     | Close Tab        |
| `;<Tab>f`     | `n`  | —     | First Tab        |
| `;<Tab>l`     | `n`  | —     | Last Tab         |
| `;<Tab>o`     | `n`  | —     | Close Other Tabs |
| `te`          | `n`  | —     | :tabedit         |

### Windows & splits

| Key   | Mode | Where | Action             |
| ----- | ---- | ----- | ------------------ |
| `;-`  | `n`  | —     | Split Window Below |
| `;wd` | `n`  | —     | Delete Window      |
| `;wm` | `n`  | —     | Toggle Zoom Mode   |
| `;\|` | `n`  | —     | Split Window Right |
| `sh`  | `n`  | —     | `<C-W>h`           |
| `sj`  | `n`  | —     | `<C-W>j`           |
| `sk`  | `n`  | —     | `<C-W>k`           |
| `sl`  | `n`  | —     | `<C-W>l`           |
| `ss`  | `n`  | —     | `:split<CR>`       |
| `sv`  | `n`  | —     | `:vsplit<CR>`      |

### Editing & motion

| Key    | Mode  | Where    | Action                          |
| ------ | ----- | -------- | ------------------------------- |
| `%`    | `n`   | —        | Jump to matching pair (matchit) |
| `%`    | `o`   | —        | Jump to matching pair (matchit) |
| `%`    | `x`   | —        | Jump to matching pair (matchit) |
| `,`    | `nxo` | —        | Flash: repeat char motion       |
| `<lt>` | `x`   | —        | Dedent, keep selection          |
| `>`    | `x`   | —        | Indent, keep selection          |
| `\\`   | `n`   | —        | Buffers                         |
| `\r`   | `nx`  | lua      | Run Lua                         |
| `a`    | `xo`  | —        | Around textobject               |
| `a%`   | `x`   | —        | Jump to matching pair (matchit) |
| `al`   | `xo`  | —        | Around last textobject          |
| `an`   | `xo`  | —        | Around next textobject          |
| `F`    | `nxo` | —        | Flash: jump backward to char    |
| `f`    | `nxo` | —        | Flash: jump forward to char     |
| `i`    | `xo`  | —        | Inside textobject               |
| `ih`   | `xo`  | git repo | GitSigns Select Hunk            |
| `il`   | `xo`  | —        | Inside last textobject          |
| `in`   | `xo`  | —        | Inside next textobject          |
| `j`    | `nx`  | —        | Down                            |
| `K`    | `n`   | LSP      | Hover                           |
| `k`    | `nx`  | —        | Up                              |
| `M`    | `nxo` | —        | Flash Treesitter                |
| `m`    | `nxo` | —        | Flash                           |
| `N`    | `nxo` | —        | Prev Search Result              |
| `n`    | `nxo` | —        | Next Search Result              |
| `R`    | `xo`  | —        | Treesitter Search               |
| `r`    | `o`   | —        | Remote Flash                    |
| `sf`   | `n`   | —        | Explorer (buffer dir)           |
| `T`    | `nxo` | —        | Flash: jump back before char    |
| `t`    | `nxo` | —        | Flash: jump before char         |

### Prev / next

| Key        | Mode   | Where      | Action                                             |
| ---------- | ------ | ---------- | -------------------------------------------------- |
| `[<Space>` | `n`    | —          | Add empty line above cursor                        |
| `[%`       | `n`    | —          | Prev unmatched group (matchit)                     |
| `[%`       | `o`    | —          | Prev unmatched group (matchit)                     |
| `[%`       | `x`    | —          | Prev unmatched group (matchit)                     |
| `[<C-L>`   | `n`    | —          | :lpfile                                            |
| `[<C-Q>`   | `n`    | —          | :cpfile                                            |
| `[<C-T>`   | `n`    | —          | :ptprevious                                        |
| `[[`       | `n`    | treesitter | Prev Reference                                     |
| `[[`       | `o`    | python     | Jump to previous section                           |
| `[[`       | `xos`  | go         | Jump to previous section                           |
| `[]`       | `nxo`  | python     | Jump to previous class/def end                     |
| `[]`       | `nxos` | go         | Jump to previous section end                       |
| `[A`       | `nxo`  | treesitter | Prev Parameter End                                 |
| `[A`       | `n`    | —          | :rewind                                            |
| `[a`       | `nxo`  | treesitter | Prev Parameter Start                               |
| `[a`       | `n`    | —          | :previous                                          |
| `[B`       | `n`    | —          | Move buffer prev                                   |
| `[b`       | `n`    | —          | Prev Buffer                                        |
| `[C`       | `nxo`  | treesitter | Prev Class End                                     |
| `[c`       | `nxo`  | treesitter | Prev Class Start                                   |
| `[D`       | `n`    | —          | Jump to the first diagnostic in the current buffer |
| `[d`       | `n`    | —          | Prev Diagnostic                                    |
| `[e`       | `n`    | —          | Prev Error                                         |
| `[F`       | `nxo`  | treesitter | Prev Function End                                  |
| `[f`       | `nxo`  | treesitter | Prev Function Start                                |
| `[H`       | `n`    | git repo   | First Hunk                                         |
| `[h`       | `n`    | git repo   | Prev Hunk                                          |
| `[L`       | `n`    | —          | :lrewind                                           |
| `[l`       | `n`    | —          | :lprevious                                         |
| `[M`       | `nxo`  | python     | Jump to previous method end                        |
| `[m`       | `nxo`  | python     | Jump to previous method start                      |
| `[N`       | `x`    | —          | Select previous sibling node                       |
| `[n`       | `x`    | —          | Select previous node                               |
| `[Q`       | `n`    | —          | :crewind                                           |
| `[q`       | `n`    | —          | Previous Trouble/Quickfix Item                     |
| `[T`       | `n`    | —          | :trewind                                           |
| `[t`       | `n`    | —          | Previous Todo Comment                              |
| `[w`       | `n`    | —          | Prev Warning                                       |
| `]<Space>` | `n`    | —          | Add empty line below cursor                        |
| `]%`       | `n`    | —          | Next unmatched group (matchit)                     |
| `]%`       | `o`    | —          | Next unmatched group (matchit)                     |
| `]%`       | `x`    | —          | Next unmatched group (matchit)                     |
| `]<C-L>`   | `n`    | —          | :lnfile                                            |
| `]<C-Q>`   | `n`    | —          | :cnfile                                            |
| `]<C-T>`   | `n`    | —          | :ptnext                                            |
| `][`       | `nxo`  | python     | Jump to next class/def end                         |
| `][`       | `nxos` | go         | Jump to next section end                           |
| `]]`       | `n`    | treesitter | Next Reference                                     |
| `]]`       | `o`    | python     | Jump to next section                               |
| `]]`       | `xos`  | go         | Jump to next section                               |
| `]A`       | `nxo`  | treesitter | Next Parameter End                                 |
| `]A`       | `n`    | —          | :last                                              |
| `]a`       | `nxo`  | treesitter | Next Parameter Start                               |
| `]a`       | `n`    | —          | :next                                              |
| `]B`       | `n`    | —          | Move buffer next                                   |
| `]b`       | `n`    | —          | Next Buffer                                        |
| `]C`       | `nxo`  | treesitter | Next Class End                                     |
| `]c`       | `nxo`  | treesitter | Next Class Start                                   |
| `]D`       | `n`    | —          | Jump to the last diagnostic in the current buffer  |
| `]d`       | `n`    | —          | Next Diagnostic                                    |
| `]e`       | `n`    | —          | Next Error                                         |
| `]F`       | `nxo`  | treesitter | Next Function End                                  |
| `]f`       | `nxo`  | treesitter | Next Function Start                                |
| `]H`       | `n`    | git repo   | Last Hunk                                          |
| `]h`       | `n`    | git repo   | Next Hunk                                          |
| `]L`       | `n`    | —          | :llast                                             |
| `]l`       | `n`    | —          | :lnext                                             |
| `]M`       | `nxo`  | python     | Jump to next method end                            |
| `]m`       | `nxo`  | python     | Jump to next method start                          |
| `]N`       | `x`    | —          | Select next sibling node                           |
| `]n`       | `x`    | —          | Select next node                                   |
| `]Q`       | `n`    | —          | :clast                                             |
| `]q`       | `n`    | —          | Next Trouble/Quickfix Item                         |
| `]T`       | `n`    | —          | :tlast                                             |
| `]t`       | `n`    | —          | Next Todo Comment                                  |
| `]w`       | `n`    | —          | Next Warning                                       |

### Goto / LSP

| Key   | Mode  | Where | Action                                                                                     |
| ----- | ----- | ----- | ------------------------------------------------------------------------------------------ |
| `g%`  | `n`   | —     | Jump to matching pair backwards (matchit)                                                  |
| `g%`  | `o`   | —     | Jump to matching pair backwards (matchit)                                                  |
| `g%`  | `x`   | —     | Jump to matching pair backwards (matchit)                                                  |
| `g[`  | `nxo` | —     | Move to left "around"                                                                      |
| `g]`  | `nxo` | —     | Move to right "around"                                                                     |
| `gai` | `n`   | LSP   | C[a]lls Incoming                                                                           |
| `gao` | `n`   | LSP   | C[a]lls Outgoing                                                                           |
| `gc`  | `nx`  | —     | Toggle comment                                                                             |
| `gc`  | `o`   | —     | Comment textobject                                                                         |
| `gcc` | `n`   | —     | Toggle comment line                                                                        |
| `gcO` | `n`   | —     | Add Comment Above                                                                          |
| `gco` | `n`   | —     | Add Comment Below                                                                          |
| `gD`  | `n`   | LSP   | Goto Declaration                                                                           |
| `gD`  | `n`   | LSP   | Goto Source Definition                                                                     |
| `gd`  | `n`   | LSP   | Goto Definition                                                                            |
| `gI`  | `n`   | LSP   | Goto Implementation                                                                        |
| `gK`  | `n`   | LSP   | Signature Help                                                                             |
| `gO`  | `n`   | —     | vim.lsp.buf.document_symbol()                                                              |
| `gR`  | `n`   | LSP   | File References                                                                            |
| `gr`  | `n`   | LSP   | References                                                                                 |
| `gra` | `nx`  | —     | vim.lsp.buf.code_action()                                                                  |
| `gri` | `n`   | —     | vim.lsp.buf.implementation()                                                               |
| `grn` | `n`   | —     | vim.lsp.buf.rename()                                                                       |
| `grr` | `n`   | —     | vim.lsp.buf.references()                                                                   |
| `grt` | `n`   | —     | vim.lsp.buf.type_definition()                                                              |
| `grx` | `n`   | —     | vim.lsp.codelens.run()                                                                     |
| `gx`  | `nx`  | —     | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| `gy`  | `n`   | LSP   | Goto T[y]pe Definition                                                                     |

### Code / LSP

| Key   | Mode | Where      | Action                                   |
| ----- | ---- | ---------- | ---------------------------------------- |
| `;cA` | `n`  | LSP        | Source Action                            |
| `;ca` | `nx` | LSP        | Code Action                              |
| `;cC` | `n`  | LSP        | Refresh & Display Codelens               |
| `;cc` | `nx` | LSP        | Run Codelens                             |
| `;cD` | `n`  | typescript | Fix all diagnostics                      |
| `;cd` | `n`  | —          | Line Diagnostics                         |
| `;cF` | `nx` | —          | Format Injected Langs                    |
| `;cf` | `nx` | —          | Format                                   |
| `;cl` | `n`  | LSP        | Lsp Info                                 |
| `;cM` | `n`  | typescript | Add missing imports                      |
| `;cm` | `n`  | —          | Mason                                    |
| `;co` | `n`  | LSP        | Organize Imports                         |
| `;cR` | `n`  | LSP        | Rename File                              |
| `;cr` | `n`  | LSP        | Rename                                   |
| `;cS` | `n`  | —          | LSP references/definitions/... (Trouble) |
| `;cs` | `n`  | —          | Symbols (Trouble)                        |
| `;cV` | `n`  | typescript | Select TS workspace version              |

### Diagnostics / lists

| Key   | Mode | Where | Action                       |
| ----- | ---- | ----- | ---------------------------- |
| `;xL` | `n`  | —     | Location List (Trouble)      |
| `;xl` | `n`  | —     | Location List                |
| `;xQ` | `n`  | —     | Quickfix List (Trouble)      |
| `;xq` | `n`  | —     | Quickfix List                |
| `;xT` | `n`  | —     | Todo/Fix/Fixme (Trouble)     |
| `;xt` | `n`  | —     | Todo (Trouble)               |
| `;xX` | `n`  | —     | Buffer Diagnostics (Trouble) |
| `;xx` | `n`  | —     | Diagnostics (Trouble)        |

### Git

| Key   | Mode | Where | Action                      |
| ----- | ---- | ----- | --------------------------- |
| `;gB` | `nx` | —     | Git Browse (open)           |
| `;gb` | `n`  | —     | Git Blame Line              |
| `;gD` | `n`  | —     | Git Diff (origin)           |
| `;gd` | `n`  | —     | Git Diff (hunks)            |
| `;ge` | `n`  | —     | Git Explorer                |
| `;gf` | `n`  | —     | Git Current File History    |
| `;gG` | `n`  | —     | Lazygit (cwd)               |
| `;gg` | `n`  | —     | Lazygit (Root Dir)          |
| `;gI` | `n`  | —     | GitHub Issues (all)         |
| `;gi` | `n`  | —     | GitHub Issues (open)        |
| `;gL` | `n`  | —     | Git Log (cwd)               |
| `;gl` | `n`  | —     | Git Log                     |
| `;gP` | `n`  | —     | GitHub Pull Requests (all)  |
| `;gp` | `n`  | —     | GitHub Pull Requests (open) |
| `;gS` | `n`  | —     | Git Stash                   |
| `;gs` | `n`  | —     | Git Status                  |
| `;gY` | `nx` | —     | Git Browse (copy)           |

### Git hunks (gitsigns)

| Key    | Mode | Where    | Action              |
| ------ | ---- | -------- | ------------------- |
| `;ghB` | `n`  | git repo | Blame Buffer        |
| `;ghb` | `n`  | git repo | Blame Line          |
| `;ghD` | `n`  | git repo | Diff This ~         |
| `;ghd` | `n`  | git repo | Diff This           |
| `;ghp` | `n`  | git repo | Preview Hunk Inline |
| `;ghR` | `n`  | git repo | Reset Buffer        |
| `;ghr` | `nx` | git repo | Reset Hunk          |
| `;ghS` | `n`  | git repo | Stage Buffer        |
| `;ghs` | `nx` | git repo | Stage Hunk          |
| `;ghu` | `n`  | git repo | Undo Stage Hunk     |

### Markdown

| Key   | Mode | Where    | Action                                |
| ----- | ---- | -------- | ------------------------------------- |
| `;cp` | `n`  | markdown | Markdown Preview                      |
| `[[`  | `n`  | markdown | Jump to previous section              |
| `[[`  | `x`  | markdown | Jump to previous section              |
| `]]`  | `n`  | markdown | Jump to next section                  |
| `]]`  | `x`  | markdown | Jump to next section                  |
| `gO`  | `n`  | markdown | Show an Outline of the current buffer |

### Test

| Key   | Mode | Where | Action                        |
| ----- | ---- | ----- | ----------------------------- |
| `;t`  | `n`  | —     | +test                         |
| `;ta` | `n`  | —     | Attach to Test (Neotest)      |
| `;td` | `n`  | go    | Debug Nearest (Go)            |
| `;td` | `n`  | —     | Debug Nearest                 |
| `;tl` | `n`  | —     | Run Last (Neotest)            |
| `;tO` | `n`  | —     | Toggle Output Panel (Neotest) |
| `;to` | `n`  | —     | Show Output (Neotest)         |
| `;tr` | `n`  | —     | Run Nearest (Neotest)         |
| `;tS` | `n`  | —     | Stop (Neotest)                |
| `;ts` | `n`  | —     | Toggle Summary (Neotest)      |
| `;tT` | `n`  | —     | Run All Test Files (Neotest)  |
| `;tt` | `n`  | —     | Run File (Neotest)            |
| `;tw` | `n`  | —     | Toggle Watch (Neotest)        |

### Debug (DAP)

| Key   | Mode | Where | Action                  |
| ----- | ---- | ----- | ----------------------- |
| `;da` | `n`  | —     | Run with Args           |
| `;dB` | `n`  | —     | Breakpoint Condition    |
| `;db` | `n`  | —     | Toggle Breakpoint       |
| `;dC` | `n`  | —     | Run to Cursor           |
| `;dc` | `n`  | —     | Run/Continue            |
| `;de` | `nx` | —     | Eval                    |
| `;dg` | `n`  | —     | Go to Line (No Execute) |
| `;di` | `n`  | —     | Step Into               |
| `;dj` | `n`  | —     | Down                    |
| `;dk` | `n`  | —     | Up                      |
| `;dl` | `n`  | —     | Run Last                |
| `;dO` | `n`  | —     | Step Over               |
| `;do` | `n`  | —     | Step Out                |
| `;dP` | `n`  | —     | Pause                   |
| `;dr` | `n`  | rust  | Rust Debuggables        |
| `;dr` | `n`  | —     | Toggle REPL             |
| `;ds` | `n`  | —     | Session                 |
| `;dt` | `n`  | —     | Terminate               |
| `;du` | `n`  | —     | Dap UI                  |
| `;dw` | `n`  | —     | Widgets                 |

### Profiler

| Key    | Mode | Where | Action                     |
| ------ | ---- | ----- | -------------------------- |
| `;dph` | `n`  | —     | Toggle Profiler Highlights |
| `;dpp` | `n`  | —     | Toggle Profiler            |
| `;dps` | `n`  | —     | Profiler Scratch Buffer    |

### Sessions

| Key   | Mode | Where | Action                     |
| ----- | ---- | ----- | -------------------------- |
| `;qd` | `n`  | —     | Don't Save Current Session |
| `;ql` | `n`  | —     | Restore Last Session       |
| `;qq` | `n`  | —     | Quit All                   |
| `;qS` | `n`  | —     | Select Session             |
| `;qs` | `n`  | —     | Restore Session            |

### Toggle / UI

| Key   | Mode | Where | Action                                |
| ----- | ---- | ----- | ------------------------------------- |
| `;uA` | `n`  | —     | Toggle Tabline                        |
| `;ua` | `n`  | —     | Toggle Animations                     |
| `;ub` | `n`  | —     | Toggle Dark Background                |
| `;uC` | `n`  | —     | Colorschemes                          |
| `;uc` | `n`  | —     | Toggle Conceal Level                  |
| `;uD` | `n`  | —     | Toggle Dimming                        |
| `;ud` | `n`  | —     | Toggle Diagnostics                    |
| `;uF` | `n`  | —     | Toggle Auto Format (Buffer)           |
| `;uf` | `n`  | —     | Toggle Auto Format (Global)           |
| `;uG` | `n`  | —     | Toggle Git Signs                      |
| `;ug` | `n`  | —     | Toggle Indent Guides                  |
| `;uh` | `n`  | —     | Toggle Inlay Hints                    |
| `;uI` | `n`  | —     | Inspect Tree                          |
| `;ui` | `n`  | —     | Inspect Pos                           |
| `;uL` | `n`  | —     | Toggle Relative Number                |
| `;ul` | `n`  | —     | Toggle Line Numbers                   |
| `;um` | `n`  | —     | Toggle Render Markdown                |
| `;un` | `n`  | —     | Dismiss All Notifications             |
| `;up` | `n`  | —     | Toggle Mini Pairs                     |
| `;ur` | `n`  | —     | Redraw / Clear hlsearch / Diff Update |
| `;uS` | `n`  | —     | Toggle Smooth Scroll                  |
| `;us` | `n`  | —     | Toggle Spelling                       |
| `;uT` | `n`  | —     | Toggle Treesitter Highlight           |
| `;uw` | `n`  | —     | Toggle Wrap                           |
| `;uZ` | `n`  | —     | Toggle Zoom Mode                      |
| `;uz` | `n`  | —     | Toggle Zen Mode                       |

### Noice (messages)

| Key    | Mode | Where | Action                          |
| ------ | ---- | ----- | ------------------------------- |
| `;sn`  | `n`  | —     | +noice                          |
| `;sna` | `n`  | —     | Noice All                       |
| `;snd` | `n`  | —     | Dismiss All                     |
| `;snh` | `n`  | —     | Noice History                   |
| `;snl` | `n`  | —     | Noice Last Message              |
| `;snt` | `n`  | —     | Noice Picker (Telescope/FzfLua) |

### Control / Alt

| Key         | Mode   | Where      | Action                                          |
| ----------- | ------ | ---------- | ----------------------------------------------- |
| `<C-/>`     | `nt`   | —          | Terminal (Root Dir)                             |
| `<C-B>`     | `nis`  | —          | Scroll Backward                                 |
| `<C-Down>`  | `n`    | —          | Decrease Window Height                          |
| `<C-F>`     | `nis`  | —          | Scroll Forward                                  |
| `<C-H>`     | `n`    | —          | Go to Left Window                               |
| `<C-J>`     | `n`    | —          | Go to Lower Window                              |
| `<C-K>`     | `i`    | LSP        | Signature Help                                  |
| `<C-K>`     | `n`    | —          | Go to Upper Window                              |
| `<C-L>`     | `n`    | —          | Go to Right Window                              |
| `<C-Left>`  | `n`    | —          | Decrease Window Width                           |
| `<C-Right>` | `n`    | —          | Increase Window Width                           |
| `<C-S>`     | `c`    | —          | Toggle Flash Search                             |
| `<C-S>`     | `nxis` | —          | Save File                                       |
| `<C-Space>` | `nxo`  | —          | Treesitter Incremental Selection                |
| `<C-Up>`    | `n`    | —          | Increase Window Height                          |
| `<Down>`    | `nx`   | —          | Down                                            |
| `<Esc>`     | `nis`  | —          | Escape and Clear hlsearch                       |
| `<M-j>`     | `nxis` | —          | Move Down                                       |
| `<M-k>`     | `nxis` | —          | Move Up                                         |
| `<M-n>`     | `n`    | treesitter | Next Reference                                  |
| `<M-p>`     | `n`    | treesitter | Prev Reference                                  |
| `<S-CR>`    | `c`    | —          | Redirect Cmdline                                |
| `<S-Tab>`   | `is`   | —          | `vim.snippet.jump if active, otherwise <S-Tab>` |
| `<S-Tab>`   | `n`    | —          | `:tabprev<CR>`                                  |
| `<Tab>`     | `is`   | —          | `vim.snippet.jump if active, otherwise <Tab>`   |
| `<Tab>`     | `n`    | —          | `:tabnext<CR>`                                  |
| `<Up>`      | `nx`   | —          | Up                                              |

## Languages

Go, Rust, TypeSpec, TypeScript/TSX, Markdown, templ, TOML, SQL, Python, Nix, fish, proto.

Go and Markdown come from the LazyVim `lang.go` / `lang.markdown` extras; `lua/plugins/`
only carries what those extras do not already provide. Prefer enabling an extra
(`:LazyExtras`) over hand-writing a language setup.

## Maintenance

| Command        |                                         |
| -------------- | --------------------------------------- |
| `:Lazy sync`   | update plugins                          |
| `:TSUpdate`    | update tree-sitter parsers              |
| `:Mason`       | manage LSP servers, formatters, linters |
| `:checkhealth` | diagnose problems                       |
| `:LazyExtras`  | toggle LazyVim extras                   |

Plugin versions are pinned in `lazy-lock.json` — commit it, and use `:Lazy restore`
to roll back to the pinned set.

## macOS Apple Silicon — Tree-sitter parser crash fix

After running `:TSInstall` or `:TSUpdate`, macOS may kill Neovim with **"Code Signature Invalid"**
because tree-sitter compiles `.so` files without code-signing them.

Re-sign all parsers after any install/update:

```sh
codesign --force -s - ~/.local/share/nvim/site/parser/*.so
```
