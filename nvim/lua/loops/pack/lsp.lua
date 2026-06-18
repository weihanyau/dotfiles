vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-lint" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

-- Initialize Mason
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

vim.lsp.enable({
	"emmylua_ls",
	"basedpyright",
	"ruff",
	"vtsls",
	"clangd",
})

-- Completion
vim.o.completeopt = "fuzzy,menuone,noselect"
vim.o.complete = ".,w,b,kspell"

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-h>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		menu = {
			auto_show = true,
		},
	},
	sources = { default = { "lsp", "path", "buffer", "snippets" } },

	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

-- Formatter
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "oxfmt" },
		typescript = { "oxfmt" },
		javascriptreact = { "oxfmt" },
		typescriptreact = { "oxfmt" },
		python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		c = { "clang_format" },
		cpp = { "clang_format" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- Linter
require("lint").linters_by_ft = {
	lua = { "luacheck" },
	javascript = { "oxlint" },
	typescript = { "oxlint" },
	javascriptreact = { "oxlint" },
	typescriptreact = { "oxlint" },
	python = { "ruff" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
