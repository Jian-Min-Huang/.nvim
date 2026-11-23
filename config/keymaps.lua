-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy "@<path relative to LazyVim root>:L<line>" to the system clipboard
vim.keymap.set("n", "<leader>vy", function()
	local file = LazyVim.root.bufpath(0)
	if not file then
		vim.notify("Current buffer has no file", vim.log.levels.WARN)
		return
	end
	local root = LazyVim.root.realpath(LazyVim.root.get({ normalize = true }))
	local path = (root and vim.fs.relpath(root, file)) or vim.fn.fnamemodify(file, ":~")
	local handle = ("@%s:L%d"):format(path, vim.fn.line("."))
	vim.fn.setreg("+", handle)
	vim.notify("Copied " .. handle)
end, { desc = "Copy @path:L<line>" })
