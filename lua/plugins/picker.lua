return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        layout = { preset = "telescope" },
        sources = {
          diagnostics = { layout = { preset = "ivy" }, focus = "list" },
          explorer = { hidden = true, ignored = true },
        },
        exclude = { "node_modules", ".git" },
      },
    },
    -- stylua: ignore
    keys = {
      { ";f",         function() Snacks.picker.files({ hidden = true }) end,                                     desc = "Find Files (hidden)" },
      { ";r",         function() Snacks.picker.grep() end,                                                       desc = "Grep" },
      { "\\\\",       function() Snacks.picker.buffers() end,                                                    desc = "Buffers" },
      -- `;t` collides with LazyVim's `<leader>t` test group and loses, so help moved to `;h`
      { ";h",         function() Snacks.picker.help() end,                                                       desc = "Help Tags" },
      { ";;",         function() Snacks.picker.resume() end,                                                     desc = "Resume Picker" },
      { ";s",         function() Snacks.picker.treesitter() end,                                                 desc = "Treesitter Symbols" },
      { "sf",         function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h") }) end,                           desc = "Explorer (buffer dir)" },
      { "<leader>fP", function() Snacks.picker.files({ cwd = require("lazy.core.config").options.root }) end,     desc = "Find Plugin File" },
    },
  },
}
