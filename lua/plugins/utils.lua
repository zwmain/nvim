return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    }, {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim", "3rd/image.nvim" -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        config = function()
            vim.keymap.set({"n", "v"}, "<leader>e", "<cmd>Neotree toggle<CR>")
        end
    }
}
