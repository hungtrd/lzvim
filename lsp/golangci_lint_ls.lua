---@type vim.lsp.Config
return {
  cmd = { "golangci-lint-langserver" },
  filetypes = { "go" },
  root_markers = { "go.mod", ".git" },
  init_options = {
    command = { "golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false" },
  },
}
