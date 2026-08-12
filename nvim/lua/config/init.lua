local CONFIG_DIRECTORY = vim.fn.stdpath("config") .. "/lua/config"
local CONFIG_FILES = vim.fn.glob(CONFIG_DIRECTORY .. "/*.lua", false, true)

for _, file in ipairs(CONFIG_FILES) do
	local CONFIG_FILENAMES = vim.fn.fnamemodify(file, ":t:r")

	if CONFIG_FILENAMES ~= "init" then
		require("config." .. CONFIG_FILENAMES)
	end
end

require("config.keymaps")
