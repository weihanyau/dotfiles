vim.pack.add({ "https://github.com/monkoose/neocodeium" })

local neocodeium = require("neocodeium")
neocodeium.setup({
	manual = false,
})
vim.keymap.set("i", "<A-f>", neocodeium.accept)
vim.keymap.set("i", "<A-e>", function()
	neocodeium.cycle_or_complete()
end)

-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "NeoCodeiumCompletionDisplayed",
-- 	callback = function()
-- 		require("blink.cmp").hide()
-- 	end,
-- })
