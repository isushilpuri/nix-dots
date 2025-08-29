return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        -- Autoformatting for specific filetypes
        local autoformat_filetypes = { "lua", "python" }

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end
                if vim.tbl_contains(autoformat_filetypes, vim.bo.filetype) then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({
                                formatting_options = { tabSize = 4, insertSpaces = true },
                                bufnr = args.buf,
                                id = client.id
                            })
                        end
                    })
                end
            end
        })

        -- Add borders to floating windows
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
        )
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = 'rounded' }
        )

        -- Configure diagnostics display
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN] = '▲',
                    [vim.diagnostic.severity.HINT] = '⚑',
                    [vim.diagnostic.severity.INFO] = '»',
                },
            },
        })

        -- Add cmp_nvim_lsp capabilities globally
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig_defaults = require('lspconfig').util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend('force', lspconfig_defaults.capabilities, capabilities)

        -- LSP keymaps
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
                vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
            end,
        })

        -- Setup Mason and Mason-LSPConfig
        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                -- "lua_ls",
                "intelephense",
                "pyright",
                -- "rust_analyzer"
            },
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities
                    })
                end,
                ["pyright"] = function()
                    require('lspconfig').pyright.setup({
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "basic", -- options: "off", "basic", "strict"
                                    autoImportCompletions = true,
                                    diagnosticMode = "workspace", -- or "openFilesOnly"
                                    useLibraryCodeForTypes = true,
                                },
                            },
                        },
                    })
                end,
                -- ["rust_analyzer"] = function()
                --     require('lspconfig').rust_analyzer.setup({
                --         capabilities = capabilities,
                --         settings = {
                --             ["rust-analyzer"] = {
                --                 cargo = { allFeatures = true },
                --                 checkOnSave = {
                --                     command = "clippy"
                --                 },
                --             },
                --         },
                --     })
                -- end,

                --           -- Custom handler for lua_ls
                --           lua_ls = function()
                --               -- Use Mason-installed binary for lua-language-server
                --               -- local mason_path = vim.fn.stdpath("data") .. "/mason/bin/lua-language-server"
                -- local lua_ls_path = vim.fn.exepath("lua-language-server")
                --
                --               require('lspconfig').lua_ls.setup({
                --                   -- cmd = { mason_path }, -- Explicitly set cmd to avoid "not executable" issue
                --                   cmd = { lua_ls_path }, -- Explicitly set cmd to avoid "not executable" issue
                --                   capabilities = capabilities,
                --                   settings = {
                --                       Lua = {
                --                           runtime = {
                --                               version = 'LuaJIT',
                --                           },
                --                           diagnostics = {
                --                               globals = { 'vim' },
                --                           },
                --                           workspace = {
                --                               library = vim.api.nvim_get_runtime_file("", true),
                --                               checkThirdParty = false,
                --                           },
                --                           telemetry = {
                --                               enable = false,
                --                           },
                --                       },
                --                   },
                --               })
                --           end,
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                -- LSP servers are installed via mason-lspconfig above
                -- Formatters & linters:
                "black", -- Python formatter
                -- "stylua",   -- Lua formatter
                -- "rustfmt",  -- Rust formatter
            },
            auto_update = true,
            run_on_start = true,
        })

        -- Lua Lsp setup using nix-os lua-language-server
        require('lspconfig').lua_ls.setup({
            cmd = { vim.fn.exepath("lua-language-server") },
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })

        -- Rust LSP config
        -- require('lspconfig').rust_analyzer.setup({
        --     cmd = { vim.fn.exepath("rust-analyzer") },
        --     capabilities = capabilities,
        --     settings = {
        --         ["rust-analyzer"] = {
        --             cargo = { allFeatures = true },
        --         },
        --     },
        -- })

        -- CMP Setup
        local cmp = require('cmp')
        require('luasnip.loaders.from_vscode').lazy_load()
        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
            window = {
                documentation = cmp.config.window.bordered(),
            },
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer',  keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    local n = entry.source.name
                    if n == 'nvim_lsp' then
                        item.menu = '[LSP]'
                    else
                        item.menu = string.format('[%s]', n)
                    end
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-f>'] = cmp.mapping.scroll_docs(5),
                ['<C-u>'] = cmp.mapping.scroll_docs(-5),
                ['<C-e>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    else
                        cmp.complete()
                    end
                end),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                ['<C-d>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<C-b>'] = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            }),
        })
    end
}
