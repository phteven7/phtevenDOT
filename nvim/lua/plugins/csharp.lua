return {
  -- C# syntax highlighting and indentation.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },

  -- Install the language server and formatter through Mason.
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "roslyn-language-server", "csharpier" } },
  },

  -- Use Microsoft's newer Roslyn language server. LazyVim supplies the usual
  -- LSP keymaps, completion, diagnostics, rename, and code actions.
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {},
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
    },
  },
}
