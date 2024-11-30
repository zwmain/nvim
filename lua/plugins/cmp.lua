return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", {
                "L3MON4D3/LuaSnip",
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
                build = "make install_jsregexp"
            }
        },
        opts = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                           vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(
                               col, col):match("%s") == nil
            end
            -- Set up nvim-cmp.
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        luasnip.lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
                    end
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, {"i", "s"}),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {"i", "s"}),

                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm({select = true})
                            end
                        else
                            fallback()
                        end
                    end)
                }),
                sources = cmp.config.sources({
                    {name = "nvim_lsp"}, {name = "path"}
                    -- { name = 'luasnip' }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                }, {{name = "buffer"}})
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({"/", "?"}, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {{name = "buffer"}}
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({{name = "path"}},
                                             {{name = "cmdline"}}),
                matching = {disallow_symbol_nonprefix_matching = false}
            })

            -- Set up lspconfig.
            -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            -- local lspCfg = require("lspconfig")
            -- lspCfg['lua_ls'].setup({capabilities = capabilities})
        end
    }, {
        "stevearc/conform.nvim",
        opts = function()
            local conform = require("conform")
            conform.formatters = {
                clang_format = {
                    prepend_args = {"--style={BasedOnStyle: WebKit}"}
                },
                ["lua-format"] = {
                    prepend_args = {"--single-quote-to-double-quote"}
                }
            }
            conform.setup({
                formatters_by_ft = {
                    lua = {"lua-format"},
                    cpp = {"clang_format"},
                    c = {"clang_format"}
                }
                -- format_on_save = {
                --     -- These options will be passed to conform.format() test
                --     timeout_ms = 500,
                --     lsp_format = "fallback"
                -- },
                -- keys = {
                --     {
                --         "<leader>f",
                --         function()
                --             require("conform").format({
                --                 async = true,
                --                 lsp_fallback = true
                --             })
                --         end,
                --         mode = {"n", "v"},
                --         desc = "Format buffer"
                --     }
                -- }
            })
            vim.api.nvim_create_user_command("Fmt", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0,
                                                                args.line2 - 1,
                                                                args.line2, true)[1]
                    range = {
                        start = {args.line1, 0},
                        ["end"] = {args.line2, end_line:len()}
                    }
                end
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                    range = range
                })
            end, {range = true})
        end
    }
}
