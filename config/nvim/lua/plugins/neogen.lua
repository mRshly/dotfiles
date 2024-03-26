return {
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },

    opts = function()
      return {
        enabled = true,
        input_after_comment = true,
        snippet_engine = "luasnip",
        languages = {
          ["python.google_docstrings"] = require("neogen.configurations.python"),
        },
      }
    end,

    keys = {
      {
        "<Leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen code annotation",
      },
    },
  },
}
