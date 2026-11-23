-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy "@<absolute path>" to the system clipboard
-- In Visual mode, also add the selected lines: "@<absolute path>:L<start>-L<end>"
vim.keymap.set({ "n", "x" }, "<leader>vy", function()
	local file = vim.fn.expand("%:p")
	if vim.bo.buftype ~= "" or file == "" then
		vim.notify("Current buffer has no file", vim.log.levels.WARN)
		return
	end
	-- Resolve symlinks; a new file not yet saved has no real path, so keep it as is
	local path = vim.uv.fs_realpath(file) or file
	local handle = "@" .. path
	if vim.fn.mode():match("^[vV\22]") then
		-- line("v") is where the Visual selection started
		local first = math.min(vim.fn.line("v"), vim.fn.line("."))
		local last = math.max(vim.fn.line("v"), vim.fn.line("."))
		local lines = first == last and ("L%d"):format(first) or ("L%d-L%d"):format(first, last)
		handle = ("%s:%s"):format(handle, lines)
		vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
	end
	vim.fn.setreg("+", handle)
	vim.notify("Copied " .. handle)
end, { desc = "Copy @path[:L<start>-L<end>]" })
