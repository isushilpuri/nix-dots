return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim", -- ensure telescope loads first
    },
    config = function()
	local harpoon = require("harpoon")
	local themes = require("telescope.themes")

	-- helper function to use telescope on harpoon list
	local function toggle_telescope(harpoon_files)
	    local ok, conf = pcall(require, "telescope.config")
	    if not ok then
		vim.notify("Telescope not loaded yet!", vim.log.levels.WARN)
		return
	    end
	    local conf_values = conf.values

	    local file_paths = {}
	    for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	    end

	    local opts = themes.get_ivy({
		prompt_title = "Working List"
	    })

	    require("telescope.pickers").new(opts, {
		finder = require("telescope.finders").new_table({
		    results = file_paths,
		}),
		previewer = conf_values.file_previewer(opts),
		sorter = conf_values.generic_sorter(opts),
	    }):find()
	end

	-- Keymaps
	vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
	vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
	vim.keymap.set("n", "<leader>fl", function() toggle_telescope(harpoon:list()) end,
	    { desc = "Open harpoon window" })
	vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
	vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
    end
}

