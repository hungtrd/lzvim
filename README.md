# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## macOS Apple Silicon — Tree-sitter parser crash fix

After running `:TSInstall` or `:TSUpdate`, macOS may kill Neovim with **"Code Signature Invalid"**
because tree-sitter compiles `.so` files without code-signing them.

Re-sign all parsers after any install/update:

```sh
codesign --force -s - ~/.local/share/nvim/site/parser/*.so
```
