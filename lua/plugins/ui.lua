return {
    {
        "folke/tokyonight.nvim",
        config = function() vim.cmd [[colorscheme tokyonight]] end
    }, {"akinsho/bufferline.nvim", config = true}, {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {}
    }, {"lewis6991/gitsigns.nvim", config = true}
}
