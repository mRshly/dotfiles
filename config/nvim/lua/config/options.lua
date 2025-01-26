-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.mouse = ""

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Python path
-- TODO: set those paths when just open python file.
package.path = package.path
  .. ";"
  .. vim.fn.expand("$HOME")
  .. "/.local/share/mise/installs/python/latest/bin/python;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.config/python/.venv/bin/python;"

vim.g.python3_host_prog = vim.fn.expand("$HOME/.config/python/.venv/bin/python3")

-- clipboard
-- https://github.com/wez/wezterm/discussions/5231
vim.o.clipboard = "unnamedplus"
if os.getenv("SSH_CLIENT") ~= nil or os.getenv("SSH_TTY") ~= nil then
  local function my_paste(_)
    return function(_)
      local content = vim.fn.getreg('"')
      return vim.split(content, "\n")
    end
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = my_paste("+"),
      ["*"] = my_paste("*"),
    },
  }
end
