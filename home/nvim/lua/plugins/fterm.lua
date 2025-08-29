return {
    "numToStr/FTerm.nvim",
    config = function()
        require("FTerm").setup({
            -- Optional: Configure FTerm settings here
            -- For example, to set a double border and specific dimensions:
            cmd = { 'zsh', '-l' },
            border = 'double',
            dimensions = { height = 0.9, width = 0.9 },
        })
        vim.keymap.set('n', '<A-i>', '<CMD>lua require("FTerm").toggle()<CR>')
        vim.keymap.set('t', '<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
}
