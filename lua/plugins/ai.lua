-- Temporary Copilot kill switch. Flip to true (or delete this file) to bring it back.
--
-- The `ai.copilot` extra stays enabled in lazyvim.json so nothing else has to change; this
-- just turns off the three pieces it installs. Disabling only copilot.lua is not enough —
-- blink.cmp would still list a `copilot` source whose provider module needs it.
local copilot = false

return {
  { "zbirenbaum/copilot.lua", enabled = copilot },
  { "fang2hou/blink-copilot", enabled = copilot },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      if not copilot then
        opts.sources.default = vim.tbl_filter(function(source)
          return source ~= "copilot"
        end, opts.sources.default or {})
        if opts.sources.providers then
          opts.sources.providers.copilot = nil
        end
      end
    end,
  },
}
