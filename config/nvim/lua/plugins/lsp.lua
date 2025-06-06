return {
  {
    "folke/neoconf.nvim",
    config = function()
      require("neoconf").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Lua
        "lua-language-server",
        "stylua",
        "selene",
        "typos-lsp",
        -- css
        "tailwindcss-language-server",
        "css-lsp",
        -- python
        "pyright",
        "ruff",
        "black",
        -- docker
        "dockerfile-language-server",
        "docker-compose-language-service",
        -- web
        "typescript-language-server",
        -- shell
        "shellcheck",
      })
    end,
  },
}
