return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    -- opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
    --   javascript = { "prettier" },
    --   typescript = { "prettier" },
    --   sh = { "shfmt" },
    -- })

    -- opts.formatters = vim.tbl_extend("force", opts.formatters or {}, {
    --   shfmt = { prepend_args = { "-i", "2", "-ci" } },
    -- })

    -- Tuỳ chọn: truyền thêm option cho conform.format()
    -- opts.format = vim.tbl_extend("force", opts.format or {}, {
    --   timeout_ms = 5000,
    -- })
    opts.formatters = {
      ["markdown-toc"] = {
        condition = function(_, ctx)
          for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
            if line:find("<!%-%- toc %-%->") then
              return true
            end
          end
        end,
      },
      ["markdownlint-cli2"] = {
        condition = function(_, ctx)
          local diag = vim.tbl_filter(function(d)
            return d.source == "markdownlint"
          end, vim.diagnostic.get(ctx.buf))
          return #diag > 0
        end,
      },
    }
    opts.formatters_by_ft = {
      ["nix"] = { "nixfmt" },
      ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["yaml"] = { "prettier" }
    }
  end,
}
