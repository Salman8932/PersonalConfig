local KEYMAPS_DIRECTORY = vim.fn.stdpath("config") .. "/lua/config/keymaps"
local KEYMAPS_FILES = vim.fn.glob(KEYMAPS_DIRECTORY .. "/*.lua", false, true)

for _, file in ipairs(KEYMAPS_FILES) do
	local KEYMAPS_FILENAMES = vim.fn.fnamemodify(file, ":t:r")

	if KEYMAPS_FILENAMES ~= "init" then
		require("config.keymaps." .. KEYMAPS_FILENAMES)
	end
end
