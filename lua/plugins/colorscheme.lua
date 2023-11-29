return {
  "EdenEast/nightfox.nvim",
  lazy = true,
  priority = 1000,
  opts = function()
    return {
      transparent = false,
      terminal_colors = true,
      dim_inactive = false,
      styles = {
        comments = "italic",
      },
    }
  end,
}
