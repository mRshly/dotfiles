local function prefer_bin_from_venv(executable_name)
  -- Return the path to the executable if $VIRTUAL_ENV is set and the binary exists somewhere beneath the $VIRTUAL_ENV path, otherwise get it from Mason
  if vim.env.VIRTUAL_ENV then
    local paths = vim.fn.glob(vim.env.VIRTUAL_ENV .. "/**/bin/" .. executable_name, true, true)
    local executable_path = table.concat(paths, ", ")
    if executable_path ~= "" then
      -- vim.api.nvim_echo(
      -- 	{ { "Using path for " .. executable_name .. ": " .. executable_path, "None" } },
      -- 	false,
      -- 	{}
      -- )
      return executable_path
    end
  end

  local mason_registry = require("mason-registry")
  local mason_path = mason_registry.get_package(executable_name):get_install_path() .. "/venv/bin/" .. executable_name
  -- vim.api.nvim_echo({ { "Using path for " .. executable_name .. ": " .. mason_path, "None" } }, false, {})
  return mason_path
end

return {
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
        "ruff-lsp",
        "ruff",
        "mypy",
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
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    opts = function(_, opts)
      local linters = require("lint").linters

      linters.mypy.cmd = prefer_bin_from_venv("mypy")

      local linters_by_ft = {
        protobuf = { "buf", "protolint" },
        python = { "mypy" },
        sh = { "shellcheck" },
        sql = { "sqlfluff" },
        yaml = { "yamllint" },
      }

      -- extend opts.linters_by_ft
      for ft, linters_ in pairs(linters_by_ft) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        vim.list_extend(opts.linters_by_ft[ft], linters_)
      end
    end,
  },
}
