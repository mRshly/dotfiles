return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- LazyVim's Python extra defaults to Pyright. Use Astral's ty instead.
      for _, server in ipairs({ "pyright", "basedpyright", "ruff_lsp" }) do
        opts.servers[server] = opts.servers[server] or {}
        opts.servers[server].enabled = false
      end

      opts.servers.ty = vim.tbl_deep_extend("force", opts.servers.ty or {}, {
        enabled = true,
      })
      opts.servers.ruff = vim.tbl_deep_extend("force", opts.servers.ruff or {}, {
        enabled = true,
      })
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
      { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv", ft = "python" },
    },
  },
}
