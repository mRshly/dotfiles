return {
  {
    "mason-org/mason.nvim",
    -- version = "^2.0.0",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim" },
      { "neovim/nvim-lspconfig" },
    },
    -- version = "^2.0.0",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
    keys = {
      { "<C-space>", "<cmd>lua vim.lsp.completion.get()  <CR>", mode = "i" },
      { "gh",        "<cmd>lua vim.lsp.buf.hover()       <CR>" },
      { "gd",        "<cmd>lua vim.lsp.buf.destination() <CR>" },
      { "gD",        "<cmd>lua vim.lsp.buf.declaration() <CR>" },
    },
  },
  config = function()
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end
      end
    end
    require('lspconfig').typos_lsp.setup({
      cmd_env = { RUST_LOG = "error" },
      init_options = {
        -- if there is '.typos.toml' at project-root, load first it.
        config             = "~/.config/nvim/spell/.typos.toml",
        diagnosticSeverity = "Error"
      }
    })
  end,
}
