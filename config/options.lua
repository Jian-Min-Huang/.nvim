-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Yank to both pbcopy and OSC 52, so the attached terminal (e.g. Termius over
-- SSH/herdr) gets the text too. Paste reads pbpaste, which always holds the
-- last yank, instead of waiting on an OSC 52 read reply from the terminal.
vim.opt.clipboard = "unnamedplus"

local osc52_copy = require("vim.ui.clipboard.osc52").copy("+")
local function copy(lines)
  osc52_copy(lines)
  vim.system({ "pbcopy" }, { stdin = table.concat(lines, "\n") }):wait()
end

vim.g.clipboard = {
  name = "OSC 52 + pbcopy",
  copy = { ["+"] = copy, ["*"] = copy },
  paste = { ["+"] = { "pbpaste" }, ["*"] = { "pbpaste" } },
}
