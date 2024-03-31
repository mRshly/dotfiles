return {
  require("mini.surround").setup({
    custom_surroundings = {
      -- TODO: I want to use this with specific filetypes
      -- bracket without space
      ["("] = { input = { "%b()", "^.().*().$" }, output = { left = "(", right = ")" } },
      ["["] = { input = { "%b[]", "^.().*().$" }, output = { left = "[", right = "]" } },
      ["{"] = { input = { "%b{}", "^.().*().$" }, output = { left = "{", right = "}" } },
      ["<"] = { input = { "%b<>", "^.().*().$" }, output = { left = "<", right = ">" } },
    },
  }),
}
