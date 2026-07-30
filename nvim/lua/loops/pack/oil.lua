vim.pack.add({
	{ src = "https://www.github.com/stevearc/oil.nvim" },
})

require("oil").setup({
	delete_to_trash = false,
	view_options = {
		show_hidden = true,
	},
	keymaps = {
		["<C-c>"] = { "<Nop>", mode = "n" },
		["<C-s>"] = { "actions.select", opts = { horizontal = true } },
		["<C-v>"] = { "actions.select", opts = { vertical = true } },
		["<C-h>"] = false,
		-- Copy absolute path of the entry under the cursor to the system clipboard
		["<leader>P"] = {
			desc = "Copy absolute path to system clipboard",
			callback = function()
				local oil = require("oil")
				local entry = oil.get_cursor_entry()
				local dir = oil.get_current_dir()
				if not entry or not dir then
					return
				end
				-- Combine directory and entry name to create the full path
				local full_path = dir .. entry.name
				vim.fn.setreg("+", full_path)
				vim.notify("Copied: " .. full_path)
			end,
		},

		-- Copy relative path of the entry under the cursor to the system clipboard
		["<leader>p"] = {
			desc = "Copy relative path to system clipboard",
			callback = function()
				local oil = require("oil")
				local entry = oil.get_cursor_entry()
				local dir = oil.get_current_dir()
				if not entry or not dir then
					return
				end
				local full_path = dir .. entry.name
				-- Convert absolute path to project-relative path
				local rel_path = vim.fn.fnamemodify(full_path, ":.")
				vim.fn.setreg("+", rel_path)
				vim.notify("Copied relative: " .. rel_path)
			end,
		},
		-- Copy the absolute path of the current directory to the system clipboard
		["<leader>D"] = {
			desc = "Copy current directory absolute path to system clipboard",
			callback = function()
				local dir = require("oil").get_current_dir()
				if dir then
					vim.fn.setreg("+", dir)
					vim.notify("Copied directory: " .. dir)
				else
					vim.notify("Could not find current directory", vim.log.levels.WARN)
				end
			end,
		},

		-- Copy the relative path of the current directory to the system clipboard
		["<leader>d"] = {
			desc = "Copy current directory relative path to system clipboard",
			callback = function()
				local dir = require("oil").get_current_dir()
				if dir then
					-- Convert the directory absolute path into a project-relative path
					local rel_dir = vim.fn.fnamemodify(dir, ":.")
					vim.fn.setreg("+", rel_dir)
					vim.notify("Copied relative directory: " .. rel_dir)
				else
					vim.notify("Could not find current directory", vim.log.levels.WARN)
				end
			end,
		},
	},
})

-- Fix for oil deleting directories causing malloc error
-- Issues: https://github.com/stevearc/oil.nvim/issues/719
local oil_fs = require("oil.fs")
local original_recursive_delete = oil_fs.recursive_delete

oil_fs.recursive_delete = function(entry_type, path, cb)
	if entry_type == "directory" then
		vim.fn.jobstart({ "rm", "-rf", path }, {
			on_exit = function(_, code)
				if code == 0 then
					cb(nil)
				else
					cb("rm -rf failed on " .. path)
				end
			end,
		})
	else
		original_recursive_delete(entry_type, path, cb)
	end
end
