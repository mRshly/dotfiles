return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Lua
        "stylua",
        "selene",
        "luacheck",
        -- css
        "tailwindcss-language-server",
        "css-lsp",
        -- web
        "typescript-language-server",
        -- shell
        "shellcheck",
      })
    end,
  },
}
