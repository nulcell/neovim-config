local cmp = require('cmp')

local options = {
    completion = {
        completeopt = 'menu,menuone',
        keyword_length = 2,
        keyword_pattern = [[\k\+]],
        get_trigger_characters = function(trigger_characters)
            return trigger_characters
        end,
        get_commit_characters = function(commit_characters)
            return commit_characters
        end,
        post_complete = function(completed_item)
            return completed_item
        end,
    },
    snippet = {
        expand = function(args)
            -- For `vsnip` user.
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

            -- For `luasnip` user.
            require('luasnip').lsp_expand(args.body)

            -- For `ultisnips` user.
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    -- You should specify your *installed* sources.
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
    },
    window = {
        -- A window source can be a `win_id` or `false`,
        -- when `false` nvim-cmp will not create an autocompletion window.
        win_id = nil,
        -- win_id = 150,
        -- The border option is the same as `|nvim_open_win|`'s option.
        -- see https://neovim.io/doc/user/api.html#nvim_open_win()
        -- You can pass any option but `style` in win_opts.
        -- NOTE: the `width` and `height` options will be overwritten by
        -- the `minimum_width` and `maximum_width` options, if the
        -- `win_height` and `win_width` options are not present.
        win_opts = {
            -- @usage pass any option to nvim_open_win
            style = "minimal",
            relative = "cursor",
            width = 60,
            height = 20,
            row = 0,
            col = 0,
        },

        -- The border characters, if `single` provided, the same border
        -- characters will be used for both border and popup win, see
        -- `|nvim_open_win|` and `|nvim_win_set_config|`
        -- border = "single",
        border = {
          {"╭", "FloatBorder"},
          {"─", "FloatBorder"},
          {"╮", "FloatBorder"},
          {"│", "FloatBorder"},
          {"╯", "FloatBorder"},
          {"─", "FloatBorder"},
          {"╰", "FloatBorder"},
          {"│", "FloatBorder"}
        },

        -- The offset option is the same as `|nvim_open_win|`'s
        -- `col`/`row`/`width`/`height` option. see
        -- https://neovim.io/doc/user/api.html#nvim_open_win()
        -- You can pass any option but `style` in offset.
        -- offset = { x = 0, y = 1 },
        offset = { width = 10, height = 10, col = 1, row = 1 },
    },
    formatting = {
        format = function(entry, vim_item)
            -- fancy icons and a name of kind
            vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
            -- set a name for each source
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                path = "[Path]",
                luasnip = "[LuaSnip]",
            })[entry.source.name]
            return vim_item
        end,
    },
    -- You can set mapping if you want.
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        -- ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    },
}

return options