vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.hlsearch = true
vim.o.scrolloff = 10
vim.o.number = true
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.undofile = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.winborder = "single"

-- plugin install
vim.pack.add({
    { name = "doom-one.nvim",  src = "https://github.com/NTBBloodbath/doom-one.nvim" },
    { name = "mini.pick",      src = "https://github.com/echasnovski/mini.pick" },
    { name = "mini.clue",      src = "https://github.com/echasnovski/mini.clue" },
    { name = "undotree",       src = "https://github.com/jiaoshijie/undotree" },
    { name = "mini.pairs",     src = "https://github.com/echasnovski/mini.pairs" },
    { name = "nvim-lspconfig", src = "https://github.com/neovim/nvim-lspconfig" },
})
-- asthetics
vim.cmd("colorscheme doom-one")
vim.cmd(":hi statusline guibg=NONE")

--lsp config
vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "gopls", "nixd", "jsonls", "cssls", "html", "clangd", "yamlls" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.api.nvim_create_user_command('DiagnosticsToggleVirtualText', function()
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not current })
end, {})
vim.keymap.set('n', '<Leader>ld', ':DiagnosticsToggleVirtualText<CR>', { noremap = true, silent = true })

--  omnicomplete
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
        end
    end,
})
vim.keymap.set('i', '<C-o>', '<C-x><C-o>', { noremap = true, silent = true })
vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy", "noinsert" }

-- system clipboard remap
vim.keymap.set({ "v", "x", "n" }, '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "x" }, '<leader>Y', '"+yy', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p', { noremap = true, silent = true })

-- mini setup
require('mini.pairs').setup({})
require('mini.pick').setup({})
vim.keymap.set('n', '<leader>sg', ":Pick grep_live<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sf', ":Pick files<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sh', ":Pick help<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', ":Pick buffers<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>.', require('mini.files').open)

-- other keymap
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})
