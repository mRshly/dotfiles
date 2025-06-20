local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

-- Function to find the project-specific ruff executable.
local function find_project_ruff(start_path)
  -- Find the project root marker.
  -- Prioritize pyproject.toml, then fall back to .git.
  local root = util.root_pattern('pyproject.toml', '.git')(start_path)

  if not root then
    -- If no project root is found, do nothing.
    return nil
  end

  -- On Windows, look for ruff.exe.
  local ruff_executable = vim.fn.has('win32') == 1 and 'ruff.exe' or 'ruff'
  local venv_ruff_path = root .. '/.venv/bin/' .. ruff_executable

  -- Check if ruff exists in .venv and is executable.
  if vim.fn.executable(venv_ruff_path) == 1 then
    -- If it's executable, return its path.
    return venv_ruff_path
  end

  return nil
end

return {
  {
    -- ruff-lsp configuration
    lspconfig.ruff_lsp.setup({
      -- Your existing settings like on_attach and capabilities should go here.
      -- on_attach = on_attach,
      -- capabilities = capabilities,

      -- Dynamically configure init_options.
      init_options = {
        server = {
          -- Find project-specific ruff based on the current buffer's path.
          path = find_project_ruff(vim.api.nvim_buf_get_name(0)),
        },
      },
    })

  },
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
    opts = {
      -- Your options go here
      -- name = "venv",
      -- auto_refresh = false
    },
    event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { '<leader>vs', '<cmd>VenvSelect<cr>' },
      -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
      { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
    },
  }
}
