return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {
          cmd_env = { RUST_LOG = "error" },
          init_options = {
            -- Prefer the shared configuration when a project has no .typos.toml.
            config = "~/.config/nvim/spell/.typos.toml",
            diagnosticSeverity = "Error",
          },
        },
      },
    },
    keys = {
      { "<C-space>", vim.lsp.completion.get, mode = "i", desc = "Trigger Completion" },
      { "gh", vim.lsp.buf.hover, desc = "Hover" },
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    },
  },
}
