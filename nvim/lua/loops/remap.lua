vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fm", "<cmd>Oil<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", [["hy:%s/<C-r>h/<C-r>h/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>aa", "<cmd>!as % -o a.o && ld a.o -o a.program<CR>", { silent = true })
vim.keymap.set("n", "<leader>as", "<cmd>!as % -o a.o && ld -shared a.o -o a.so<CR>", { silent = true })

vim.keymap.set("n", "<leader>dl", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.keymap.set("n", "<leader>oi", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = { only = { "source.organizeImports" } },
	})
end, { desc = "Organize Imports" })

vim.keymap.set("n", "<leader>cs", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = { only = { "source" } },
	})
end, { desc = "Fix All" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local opts = { buffer = event.buf }
		-- Map 'gd' to perform semantic LSP definition jumps project-wide
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	end,
})

vim.keymap.set("n", "<leader>bc", '<cmd>%bd!|e#|normal `"<CR>zz', { desc = "Close all buffers except current" })
