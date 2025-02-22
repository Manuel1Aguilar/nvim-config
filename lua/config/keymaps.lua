
local opts = { noremap=true, silent=true }
local harpoon = require("harpoon")

-- Leader mapping
vim.g.mapleader = '\\' -- Leader key set to '\'

-- Go-specific key mappings
vim.api.nvim_set_keymap('n', '<leader>gf', ':GoFmt<CR>', opts)      -- Format Go code
vim.api.nvim_set_keymap('n', '<leader>d', ':GoDoc<CR>', opts)       -- Show Go documentation
vim.api.nvim_set_keymap('n', '<leader>gd', ':GoDef<CR>', opts)      -- Go to definition
vim.api.nvim_set_keymap('n', '<leader>t', ':GoTest<CR>', opts)      -- Run tests in the current package

-- LSP-related key mappings
vim.api.nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd> lua vim.lsp.buf.implementation', opts)
vim.api.nvim_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)

-- Diagnostics navigation key mappings
vim.keymap.set('n', '[d', function() vim.diagnostic.goto_prev() end, opts)
vim.keymap.set('n', ']d', function() vim.diagnostic.goto_next() end, opts)
vim.keymap.set('n', '[h', function() vim.diagnostic.open_float() end, opts)


-- Toggleterm key mappings
vim.api.nvim_set_keymap('n', '<C-\\>', ':ToggleTerm<CR>', opts)

-- Telescope key bindings
vim.api.nvim_set_keymap('n', '<C-f>', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-g>', ':Telescope live_grep<CR>', opts)

-- NERDTree key mappings
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>', opts)

-- Vsnip
vim.api.nvim_set_keymap('i', '<C-j>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-j>"', opts)
vim.api.nvim_set_keymap('s', '<C-j>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-j>"', opts)
vim.api.nvim_set_keymap('i', '<C-k>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-k>"', opts)
vim.api.nvim_set_keymap('s', '<C-k>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-k>"', opts)

-- Toggle mode
vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', opts)
vim.api.nvim_set_keymap('n', '<C-c>', 'i', opts)

-- Harpoon
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-m>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

-- Bufferline keymaps
vim.keymap.set("n", "<leader>c", ":bdelete<CR>", opts) -- Close current buffers
vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", opts) -- Navigate to next buffer
vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", opts) -- Navigate to previous buffer
vim.keymap.set("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", opts) -- Navigate to buffer 1
vim.keymap.set("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", opts) -- Navigate to buffer 2
vim.keymap.set("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", opts) -- Navigate to buffer 3
vim.keymap.set("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", opts) -- Navigate to buffer 4
vim.keymap.set("n", "<leader>bo", ":BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>", opts) -- Close all but current buffer

-- goyo (Focus mode)
vim.api.nvim_set_keymap("n", "<leader>gw", ":Goyo<CR>", opts)

-- c#
vim.api.nvim_set_keymap('n', '<leader>cb', ':!dotnet build<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>cr', ':!dotnet run<CR>', { noremap = true })

-- Create a command to format the current file with dotnet-format
vim.api.nvim_create_user_command('DotnetFormat', function()
    vim.fn.jobstart({ 'dotnet', 'format' }, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            if data then
                print(table.concat(data, '\n')) -- Print standard output
            end
        end,
    })
end, {})

-- Optionally map a key to the command
vim.api.nvim_set_keymap('n', '<leader>df', ':DotnetFormat<CR>', { noremap = true, silent = true })

