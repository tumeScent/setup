return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"  -- packer 自身

    -- fzf 及其集成
    use { "junegunn/fzf", run = "./install --bin" }
    use "junegunn/fzf.vim"

    -- Markdown 预览
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    -- 其他插件...
    use {
        'nvim-tree/nvim-tree.lua',
        -- requires = {
            --     'nvim-tree/nvim-web-devicons', -- optional
            -- },
            'nvim-tree/nvim-web-devicons',
            config = function()
                require("nvim-tree").setup()
            end
        }

        -- toggleterm
        use {"akinsho/toggleterm.nvim", tag = '*', config = function()
            require("toggleterm").setup({
                direction = "float",
                size = 10,
            })
        end}

        -- bufferline
        use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup({
                highlights = { 
                    fill = { guibg = "NONE" },
                    background = { guibg = "NONE" } ,
                    tab = { guibg = "NONE" },
                    tab_selected = { guibg = "NONE" },
                    separator = { guibg = "NONE" },
                    separator_selected = { guibg = "NONE" },
                    separator_visible = { guibg = "NONE" },
                }, 
            })
        end
    }

    -- treesitter highlights
    use {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate'
        -- 'nvim-treesitter/nvim-treesitter',
        -- run = function()
        --     local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        --     ts_update()
        -- end,
        --
        -- config = function()
        --     require("plugin.treesitter")
        -- end
    }

    -- colorscheme
    use 'shaunsingh/nord.nvim'

    -- mason and lsp
    use {
        "williamboman/mason.nvim",
        run = ":MasonUpdate",
        config = function()
            require("plugin.lsp")
        end,
    }
    use {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },  -- 显式依赖 mason.nvim
    }
    use {
        "neovim/nvim-lspconfig",
        denpendencies = { "williamboman/mason-lspconfig.nvim" }, -- 可选
    }
    use {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },  -- 显式依赖 mason.nvim
    }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

end)

