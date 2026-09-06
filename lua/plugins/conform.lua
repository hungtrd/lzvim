return {
  "stevearc/conform.nvim",
  -- Table opts (not a function) so these merge into the defaults from LazyVim and
  -- its extras instead of replacing them. markdown/markdown.mdx are already handled
  -- by the lang.markdown extra, and go by the lang.go extra.
  opts = {
    formatters_by_ft = {
      yaml = { "prettier" },
      templ = { "templ" },
    },
  },
}
