return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.12,
      },
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        indent_blankline = { enabled = true, scope_color = "lavender" },
        mason = true,
        native_lsp = { enabled = true },
        noice = true,
        notify = true,
        snacks = true,
        treesitter = true,
        which_key = true,
      },
    },
  },
}
