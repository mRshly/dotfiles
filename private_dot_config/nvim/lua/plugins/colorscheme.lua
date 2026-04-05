return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      terminal_colors = true,
      on_highlights = function(highlights, colors)
        -- leap.nvim
        highlights.LeapMatch         = { fg = colors.yellow,  bold = true }
        highlights.LeapLabelPrimary  = { fg = colors.orange,  bold = true }
        highlights.LeapLabelSecondary = { fg = colors.magenta, bold = true }

        -- mini.nvim (mini.surround, mini.statusline etc.)
        highlights.MiniSurround      = { fg = colors.base01, bg = colors.yellow }
        highlights.MiniStatuslineModeNormal  = { fg = colors.base03, bg = colors.blue,   bold = true }
        highlights.MiniStatuslineModeInsert  = { fg = colors.base03, bg = colors.green,  bold = true }
        highlights.MiniStatuslineModeVisual  = { fg = colors.base03, bg = colors.magenta, bold = true }

        -- telescope.nvim (venv-selector 経由で使用)
        highlights.TelescopeBorder       = { fg = colors.base01 }
        highlights.TelescopePromptBorder = { fg = colors.blue }
        highlights.TelescopeSelection    = { bg = colors.base02 }
        highlights.TelescopeMatching     = { fg = colors.yellow, bold = true }
      end,
    },
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      vim.cmd([[ colorscheme solarized-osaka ]])
    end,
  },
}
