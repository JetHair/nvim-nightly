vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            hint = {
                enable = false,
            },
            diagnostics = {
                globals = { "vim" },
            },

        },
    }
})
