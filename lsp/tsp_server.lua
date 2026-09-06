---@type vim.lsp.Config
return {
  cmd = { "tsp-server", "--stdio" },
  filetypes = { "typespec" },
  -- Only use tspconfig.yaml (not .git) so each project (tsp/idp, tsp/admin)
  -- gets its own LSP instance. Shared model files (tsp/models/) are served
  -- by whichever project instance is running at the time.
  root_markers = { "tspconfig.yaml" },
}
