# 💤 Neovim

Personal [Neovim](https://neovim.io) configuration built on [LazyVim](https://lazyvim.github.io),
tuned for Go, TypeSpec, TypeScript and Java.

## Requirements

| | Why |
| --- | --- |
| **Neovim >= 0.12** | LazyVim v16 and the `nvim-treesitter` `main` branch both require it |
| `git`, `curl` | plugin manager |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | grep picker (`;r`) |
| C compiler (Xcode CLT on macOS) | building tree-sitter parsers |
| A [Nerd Font](https://www.nerdfonts.com/) | icons |
| `lazygit` *(optional)* | `;gg` |
| [`fd`](https://github.com/sharkdp/fd) *(optional)* | faster file listing; falls back to ripgrep |

Language toolchains are only needed for the languages you actually use: `go` + `templ`,
`node`, and a JDK. Everything else (LSP servers, formatters, linters, the `tree-sitter`
CLI) is installed automatically by [mason.nvim](https://github.com/mason-org/mason.nvim).

## Install

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

Plugins install on first launch. Then run `:checkhealth` and, on Apple Silicon,
the [code-signing step](#macos-apple-silicon--tree-sitter-parser-crash-fix) below.

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

Leader is `;`. Every mapping below is generated from a live session, so it reflects what
is actually bound — LazyVim defaults, plugin maps and this config's own overrides together.

Mode column: `n` normal · `x` visual · `o` operator-pending · `i` insert · `s` select ·
`c` command-line · `t` terminal.

Some entries are **buffer-local** and only exist in a matching buffer — LSP maps (`gd`, `gr`,
`K`, `;c*`) need an attached language server, and gitsigns maps (`;gh*`, `[h`, `]h`) need a
file inside a Git repository.

Press `;?` at any time for the live, buffer-aware list, or `;sk` to search all keymaps.

> **Leader collisions.** Because leader is `;`, a mapping like `;e` *is* `<leader>e`, so
> single-letter maps compete with LazyVim's groups — and the group usually wins. `;f`, `;r`
> and `;s` are claimed by this config and do win, at the cost of a `timeoutlen` delay on
> `;f*`, `;r*` and `;s*`. Free letters: `a j k m p v y z`.

### General

| Key | Mode | Action |
| --- | --- | --- |
| `;<Space>` | `n` | Find Files (Root Dir) |
| `;;` | `n` | Resume Picker |
| `;.` | `n` | Toggle Scratch Buffer |
| `;/` | `n` | Grep (Root Dir) |
| `;:` | `n` | Command History |
| `;?` | `n` | Buffer Keymaps (which-key) |
| `;E` | `n` | Explorer NeoTree (cwd) |
| `;e` | `n` | Explorer NeoTree (Root Dir) |
| `;h` | `n` | Help Tags |
| `;if` | `n` | `:IfErr<CR>` |
| `;K` | `n` | Keywordprg |
| `;L` | `n` | LazyVim Changelog |
| `;l` | `n` | Lazy |
| `;n` | `n` | Notification History |
| `;O` | `n` | `O<Esc>^Da` |
| `;o` | `n` | `o<Esc>^Da` |
| `;r` | `n` | Grep |
| `;S` | `n` | Select Scratch Buffer |

### Find files

| Key | Mode | Action |
| --- | --- | --- |
| `;f` | `n` | Find Files (hidden) |
| `;fB` | `n` | Buffers (all) |
| `;fb` | `n` | Buffers |
| `;fc` | `n` | Find Config File |
| `;fE` | `n` | Explorer NeoTree (cwd) |
| `;fe` | `n` | Explorer NeoTree (Root Dir) |
| `;fF` | `n` | Find Files (cwd) |
| `;ff` | `n` | Find Files (Root Dir) |
| `;fg` | `n` | Find Files (git-files) |
| `;fn` | `n` | New File |
| `;fP` | `n` | Find Plugin File |
| `;fp` | `n` | Projects |
| `;fR` | `n` | Recent (cwd) |
| `;fr` | `n` | Recent |
| `;fT` | `n` | Terminal (cwd) |
| `;ft` | `n` | Terminal (Root Dir) |

### Search / pickers

| Key | Mode | Action |
| --- | --- | --- |
| `;s` | `n` | Treesitter Symbols |
| `;s"` | `n` | Registers |
| `;s/` | `n` | Search History |
| `;sa` | `n` | Autocmds |
| `;sB` | `n` | Grep Open Buffers |
| `;sb` | `n` | Buffer Lines |
| `;sC` | `n` | Commands |
| `;sc` | `n` | Command History |
| `;sD` | `n` | Buffer Diagnostics |
| `;sd` | `n` | Diagnostics |
| `;sG` | `n` | Grep (cwd) |
| `;sg` | `n` | Grep (Root Dir) |
| `;sH` | `n` | Highlights |
| `;sh` | `n` | Help Pages |
| `;si` | `n` | Icons |
| `;sj` | `n` | Jumps |
| `;sk` | `n` | Keymaps |
| `;sl` | `n` | Location List |
| `;sM` | `n` | Man Pages |
| `;sm` | `n` | Marks |
| `;sp` | `n` | Search for Plugin Spec |
| `;sq` | `n` | Quickfix List |
| `;sR` | `n` | Resume |
| `;sr` | `nx` | Search and Replace |
| `;sS` | `n` | LSP Workspace Symbols |
| `;ss` | `n` | LSP Symbols |
| `;sT` | `n` | Todo/Fix/Fixme |
| `;st` | `n` | Todo |
| `;su` | `n` | Undotree |
| `;sW` | `nx` | Visual selection or word (cwd) |
| `;sw` | `nx` | Visual selection or word (Root Dir) |

### Buffers

| Key | Mode | Action |
| --- | --- | --- |
| `;,` | `n` | Buffers |
| `` ;` `` | `n` | Switch to Other Buffer |
| `;bb` | `n` | Switch to Other Buffer |
| `;bD` | `n` | Delete Buffer and Window |
| `;bd` | `n` | Delete Buffer |
| `;be` | `n` | Buffer Explorer |
| `;bi` | `n` | Delete Invisible Buffers |
| `;bj` | `n` | Pick Buffer |
| `;bl` | `n` | Delete Buffers to the Left |
| `;bo` | `n` | Delete Other Buffers |
| `;bP` | `n` | Delete Non-Pinned Buffers |
| `;bp` | `n` | Toggle Pin |
| `;br` | `n` | Delete Buffers to the Right |
| `H` | `n` | Prev Buffer |
| `L` | `n` | Next Buffer |

### Tabs

| Key | Mode | Action |
| --- | --- | --- |
| `;<Tab><Tab>` | `n` | New Tab |
| `;<Tab>[` | `n` | Previous Tab |
| `;<Tab>]` | `n` | Next Tab |
| `;<Tab>d` | `n` | Close Tab |
| `;<Tab>f` | `n` | First Tab |
| `;<Tab>l` | `n` | Last Tab |
| `;<Tab>o` | `n` | Close Other Tabs |
| `te` | `n` | :tabedit |

### Windows & splits

| Key | Mode | Action |
| --- | --- | --- |
| `;-` | `n` | Split Window Below |
| `;wd` | `n` | Delete Window |
| `;wm` | `n` | Toggle Zoom Mode |
| `;\|` | `n` | Split Window Right |
| `sh` | `n` | `<C-W>h` |
| `sj` | `n` | `<C-W>j` |
| `sk` | `n` | `<C-W>k` |
| `sl` | `n` | `<C-W>l` |
| `ss` | `n` | `:split<CR>` |
| `sv` | `n` | `:vsplit<CR>` |

### Editing & motion

| Key | Mode | Action |
| --- | --- | --- |
| `%` | `n` | Jump to matching pair (matchit) |
| `%` | `x` | Jump to matching pair (matchit) |
| `%` | `o` | Jump to matching pair (matchit) |
| `,` | `nxo` | Flash: repeat char motion |
| `<lt>` | `x` | Dedent, keep selection |
| `>` | `x` | Indent, keep selection |
| `\\` | `n` | Buffers |
| `\r` | `nx` | Run Lua |
| `a` | `xo` | Around textobject |
| `a%` | `x` | Around matching pair (matchit) |
| `al` | `xo` | Around last textobject |
| `an` | `xo` | Around next textobject |
| `F` | `nxo` | Flash: jump backward to char |
| `f` | `nxo` | Flash: jump forward to char |
| `i` | `xo` | Inside textobject |
| `ih` | `xo` | GitSigns Select Hunk |
| `il` | `xo` | Inside last textobject |
| `in` | `xo` | Inside next textobject |
| `j` | `nx` | Down |
| `K` | `n` | Hover |
| `k` | `nx` | Up |
| `M` | `nxo` | Flash Treesitter |
| `m` | `nxo` | Flash |
| `N` | `nxo` | Prev Search Result |
| `n` | `nxo` | Next Search Result |
| `R` | `xo` | Treesitter Search |
| `r` | `o` | Remote Flash |
| `sf` | `n` | Explorer (buffer dir) |
| `T` | `nxo` | Flash: jump back before char |
| `t` | `nxo` | Flash: jump before char |

### Prev / next

| Key | Mode | Action |
| --- | --- | --- |
| `[<Space>` | `n` | Add empty line above cursor |
| `[%` | `n` | Prev unmatched group (matchit) |
| `[%` | `x` | Prev unmatched group (matchit) |
| `[%` | `o` | Prev unmatched group (matchit) |
| `[<C-L>` | `n` | :lpfile |
| `[<C-Q>` | `n` | :cpfile |
| `[<C-T>` | `n` | :ptprevious |
| `[[` | `n` | Prev Reference |
| `[[` | `ov` | `<Cmd>call <SNR>32_GoFindSection('prev_start', v:count1)<CR>` |
| `[]` | `n` | `<Cmd>call <SNR>32_GoFindSection('prev_end', v:count1)<CR>` |
| `[A` | `n` | :rewind |
| `[A` | `nxo` | Prev Parameter End |
| `[a` | `n` | :previous |
| `[a` | `nxo` | Prev Parameter Start |
| `[B` | `n` | Move buffer prev |
| `[b` | `n` | Prev Buffer |
| `[C` | `nxo` | Prev Class End |
| `[c` | `nxo` | Prev Class Start |
| `[D` | `n` | Jump to the first diagnostic in the current buffer |
| `[d` | `n` | Prev Diagnostic |
| `[e` | `n` | Prev Error |
| `[F` | `nxo` | Prev Function End |
| `[f` | `nxo` | Prev Function Start |
| `[H` | `n` | First Hunk |
| `[h` | `n` | Prev Hunk |
| `[L` | `n` | :lrewind |
| `[l` | `n` | :lprevious |
| `[N` | `x` | Select previous sibling node |
| `[n` | `x` | Select previous node |
| `[Q` | `n` | :crewind |
| `[q` | `n` | Previous Trouble/Quickfix Item |
| `[T` | `n` | :trewind |
| `[t` | `n` | Previous Todo Comment |
| `[w` | `n` | Prev Warning |
| `]<Space>` | `n` | Add empty line below cursor |
| `]%` | `n` | Next unmatched group (matchit) |
| `]%` | `x` | Next unmatched group (matchit) |
| `]%` | `o` | Next unmatched group (matchit) |
| `]<C-L>` | `n` | :lnfile |
| `]<C-Q>` | `n` | :cnfile |
| `]<C-T>` | `n` | :ptnext |
| `][` | `n` | `<Cmd>call <SNR>32_GoFindSection('next_end', v:count1)<CR>` |
| `]]` | `n` | Next Reference |
| `]]` | `ov` | `<Cmd>call <SNR>32_GoFindSection('next_start', v:count1)<CR>` |
| `]A` | `n` | :last |
| `]A` | `nxo` | Next Parameter End |
| `]a` | `n` | :next |
| `]a` | `nxo` | Next Parameter Start |
| `]B` | `n` | Move buffer next |
| `]b` | `n` | Next Buffer |
| `]C` | `nxo` | Next Class End |
| `]c` | `nxo` | Next Class Start |
| `]D` | `n` | Jump to the last diagnostic in the current buffer |
| `]d` | `n` | Next Diagnostic |
| `]e` | `n` | Next Error |
| `]F` | `nxo` | Next Function End |
| `]f` | `nxo` | Next Function Start |
| `]H` | `n` | Last Hunk |
| `]h` | `n` | Next Hunk |
| `]L` | `n` | :llast |
| `]l` | `n` | :lnext |
| `]N` | `x` | Select next sibling node |
| `]n` | `x` | Select next node |
| `]Q` | `n` | :clast |
| `]q` | `n` | Next Trouble/Quickfix Item |
| `]T` | `n` | :tlast |
| `]t` | `n` | Next Todo Comment |
| `]w` | `n` | Next Warning |

### Goto / LSP

| Key | Mode | Action |
| --- | --- | --- |
| `g%` | `n` | Jump to matching pair backwards (matchit) |
| `g%` | `x` | Jump to matching pair backwards (matchit) |
| `g%` | `o` | Jump to matching pair backwards (matchit) |
| `g[` | `nxo` | Move to left "around" |
| `g]` | `nxo` | Move to right "around" |
| `gai` | `n` | C[a]lls Incoming |
| `gao` | `n` | C[a]lls Outgoing |
| `gc` | `nx` | Toggle comment |
| `gc` | `o` | Comment textobject |
| `gcc` | `n` | Toggle comment line |
| `gcO` | `n` | Add Comment Above |
| `gco` | `n` | Add Comment Below |
| `gD` | `n` | Goto Declaration |
| `gd` | `n` | Goto Definition |
| `gI` | `n` | Goto Implementation |
| `gK` | `n` | Signature Help |
| `gO` | `n` | vim.lsp.buf.document_symbol() |
| `gr` | `n` | References |
| `gra` | `nx` | vim.lsp.buf.code_action() |
| `gri` | `n` | vim.lsp.buf.implementation() |
| `grn` | `n` | vim.lsp.buf.rename() |
| `grr` | `n` | vim.lsp.buf.references() |
| `grt` | `n` | vim.lsp.buf.type_definition() |
| `grx` | `n` | vim.lsp.codelens.run() |
| `gx` | `nx` | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| `gy` | `n` | Goto T[y]pe Definition |

### Code / LSP

| Key | Mode | Action |
| --- | --- | --- |
| `;cA` | `n` | Source Action |
| `;ca` | `nx` | Code Action |
| `;cC` | `n` | Refresh & Display Codelens |
| `;cc` | `nx` | Run Codelens |
| `;cd` | `n` | Line Diagnostics |
| `;cF` | `nx` | Format Injected Langs |
| `;cf` | `nx` | Format |
| `;cl` | `n` | Lsp Info |
| `;cm` | `n` | Mason |
| `;co` | `n` | Organize Imports |
| `;cR` | `n` | Rename File |
| `;cr` | `n` | Rename |
| `;cS` | `n` | LSP references/definitions/... (Trouble) |
| `;cs` | `n` | Symbols (Trouble) |

### Diagnostics / lists

| Key | Mode | Action |
| --- | --- | --- |
| `;xL` | `n` | Location List (Trouble) |
| `;xl` | `n` | Location List |
| `;xQ` | `n` | Quickfix List (Trouble) |
| `;xq` | `n` | Quickfix List |
| `;xT` | `n` | Todo/Fix/Fixme (Trouble) |
| `;xt` | `n` | Todo (Trouble) |
| `;xX` | `n` | Buffer Diagnostics (Trouble) |
| `;xx` | `n` | Diagnostics (Trouble) |

### Git

| Key | Mode | Action |
| --- | --- | --- |
| `;gB` | `nx` | Git Browse (open) |
| `;gb` | `n` | Git Blame Line |
| `;gD` | `n` | Git Diff (origin) |
| `;gd` | `n` | Git Diff (hunks) |
| `;ge` | `n` | Git Explorer |
| `;gf` | `n` | Git Current File History |
| `;gG` | `n` | Lazygit (cwd) |
| `;gg` | `n` | Lazygit (Root Dir) |
| `;gI` | `n` | GitHub Issues (all) |
| `;gi` | `n` | GitHub Issues (open) |
| `;gL` | `n` | Git Log (cwd) |
| `;gl` | `n` | Git Log |
| `;gP` | `n` | GitHub Pull Requests (all) |
| `;gp` | `n` | GitHub Pull Requests (open) |
| `;gS` | `n` | Git Stash |
| `;gs` | `n` | Git Status |
| `;gY` | `nx` | Git Browse (copy) |

### Git hunks (gitsigns)

| Key | Mode | Action |
| --- | --- | --- |
| `;ghB` | `n` | Blame Buffer |
| `;ghb` | `n` | Blame Line |
| `;ghD` | `n` | Diff This ~ |
| `;ghd` | `n` | Diff This |
| `;ghp` | `n` | Preview Hunk Inline |
| `;ghR` | `n` | Reset Buffer |
| `;ghr` | `nx` | Reset Hunk |
| `;ghS` | `n` | Stage Buffer |
| `;ghs` | `nx` | Stage Hunk |
| `;ghu` | `n` | Undo Stage Hunk |

### Test

| Key | Mode | Action |
| --- | --- | --- |
| `;t` | `n` | +test |
| `;ta` | `n` | Attach to Test (Neotest) |
| `;td` | `n` | Debug Nearest |
| `;td` | `n` | Debug Nearest (Go) |
| `;tl` | `n` | Run Last (Neotest) |
| `;tO` | `n` | Toggle Output Panel (Neotest) |
| `;to` | `n` | Show Output (Neotest) |
| `;tr` | `n` | Run Nearest (Neotest) |
| `;tS` | `n` | Stop (Neotest) |
| `;ts` | `n` | Toggle Summary (Neotest) |
| `;tT` | `n` | Run All Test Files (Neotest) |
| `;tt` | `n` | Run File (Neotest) |
| `;tw` | `n` | Toggle Watch (Neotest) |

### Debug (DAP)

| Key | Mode | Action |
| --- | --- | --- |
| `;da` | `n` | Run with Args |
| `;dB` | `n` | Breakpoint Condition |
| `;db` | `n` | Toggle Breakpoint |
| `;dC` | `n` | Run to Cursor |
| `;dc` | `n` | Run/Continue |
| `;de` | `nx` | Eval |
| `;dg` | `n` | Go to Line (No Execute) |
| `;di` | `n` | Step Into |
| `;dj` | `n` | Down |
| `;dk` | `n` | Up |
| `;dl` | `n` | Run Last |
| `;dO` | `n` | Step Over |
| `;do` | `n` | Step Out |
| `;dP` | `n` | Pause |
| `;dr` | `n` | Toggle REPL |
| `;ds` | `n` | Session |
| `;dt` | `n` | Terminate |
| `;du` | `n` | Dap UI |
| `;dw` | `n` | Widgets |

### Profiler

| Key | Mode | Action |
| --- | --- | --- |
| `;dph` | `n` | Toggle Profiler Highlights |
| `;dpp` | `n` | Toggle Profiler |
| `;dps` | `n` | Profiler Scratch Buffer |

### Sessions

| Key | Mode | Action |
| --- | --- | --- |
| `;qd` | `n` | Don't Save Current Session |
| `;ql` | `n` | Restore Last Session |
| `;qq` | `n` | Quit All |
| `;qS` | `n` | Select Session |
| `;qs` | `n` | Restore Session |

### Toggle / UI

| Key | Mode | Action |
| --- | --- | --- |
| `;uA` | `n` | Toggle Tabline |
| `;ua` | `n` | Toggle Animations |
| `;ub` | `n` | Toggle Dark Background |
| `;uC` | `n` | Colorschemes |
| `;uc` | `n` | Toggle Conceal Level |
| `;uD` | `n` | Toggle Dimming |
| `;ud` | `n` | Toggle Diagnostics |
| `;uF` | `n` | Toggle Auto Format (Buffer) |
| `;uf` | `n` | Toggle Auto Format (Global) |
| `;uG` | `n` | Toggle Git Signs |
| `;ug` | `n` | Toggle Indent Guides |
| `;uh` | `n` | Toggle Inlay Hints |
| `;uI` | `n` | Inspect Tree |
| `;ui` | `n` | Inspect Pos |
| `;uL` | `n` | Toggle Relative Number |
| `;ul` | `n` | Toggle Line Numbers |
| `;un` | `n` | Dismiss All Notifications |
| `;up` | `n` | Toggle Mini Pairs |
| `;ur` | `n` | Redraw / Clear hlsearch / Diff Update |
| `;uS` | `n` | Toggle Smooth Scroll |
| `;us` | `n` | Toggle Spelling |
| `;uT` | `n` | Toggle Treesitter Highlight |
| `;uw` | `n` | Toggle Wrap |
| `;uZ` | `n` | Toggle Zoom Mode |
| `;uz` | `n` | Toggle Zen Mode |

### Noice (messages)

| Key | Mode | Action |
| --- | --- | --- |
| `;sn` | `n` | +noice |
| `;sna` | `n` | Noice All |
| `;snd` | `n` | Dismiss All |
| `;snh` | `n` | Noice History |
| `;snl` | `n` | Noice Last Message |
| `;snt` | `n` | Noice Picker (Telescope/FzfLua) |

### Control / Alt

| Key | Mode | Action |
| --- | --- | --- |
| `<C-/>` | `nt` | Terminal (Root Dir) |
| `<C-B>` | `nis` | Scroll Backward |
| `<C-Down>` | `n` | Decrease Window Height |
| `<C-F>` | `nis` | Scroll Forward |
| `<C-H>` | `n` | Go to Left Window |
| `<C-J>` | `n` | Go to Lower Window |
| `<C-K>` | `n` | Go to Upper Window |
| `<C-K>` | `i` | Signature Help |
| `<C-L>` | `n` | Go to Right Window |
| `<C-Left>` | `n` | Decrease Window Width |
| `<C-Right>` | `n` | Increase Window Width |
| `<C-S>` | `nxis` | Save File |
| `<C-S>` | `c` | Toggle Flash Search |
| `<C-Space>` | `nxo` | Treesitter Incremental Selection |
| `<C-Up>` | `n` | Increase Window Height |
| `<Down>` | `nx` | Down |
| `<Esc>` | `nis` | Escape and Clear hlsearch |
| `<M-j>` | `nvi` | Move Down |
| `<M-k>` | `nvi` | Move Up |
| `<M-n>` | `n` | Next Reference |
| `<M-p>` | `n` | Prev Reference |
| `<S-CR>` | `c` | Redirect Cmdline |
| `<S-Tab>` | `n` | `:tabprev<CR>` |
| `<S-Tab>` | `is` | `vim.snippet.jump if active, otherwise <S-Tab>` |
| `<Tab>` | `n` | `:tabnext<CR>` |
| `<Tab>` | `is` | `vim.snippet.jump if active, otherwise <Tab>` |
| `<Up>` | `nx` | Up |

## Languages

Go, TypeSpec, TypeScript/TSX, Java, Markdown, templ, SQL, Rust, Python, Nix, fish, proto.

Go and Markdown come from the LazyVim `lang.go` / `lang.markdown` extras; `lua/plugins/`
only carries what those extras do not already provide. Prefer enabling an extra
(`:LazyExtras`) over hand-writing a language setup.

## Maintenance

| Command | |
| --- | --- |
| `:Lazy sync` | update plugins |
| `:TSUpdate` | update tree-sitter parsers |
| `:Mason` | manage LSP servers, formatters, linters |
| `:checkhealth` | diagnose problems |
| `:LazyExtras` | toggle LazyVim extras |

Plugin versions are pinned in `lazy-lock.json` — commit it, and use `:Lazy restore`
to roll back to the pinned set.

## macOS Apple Silicon — Tree-sitter parser crash fix

After running `:TSInstall` or `:TSUpdate`, macOS may kill Neovim with **"Code Signature Invalid"**
because tree-sitter compiles `.so` files without code-signing them.

Re-sign all parsers after any install/update:

```sh
codesign --force -s - ~/.local/share/nvim/site/parser/*.so
```
