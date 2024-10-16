
-- Go settings
vim.g.go_fmt_command = 'goimports'           -- Format with goimports
vim.g.go_auto_type_info = 1                  -- Show type info automatically
vim.g.go_def_mode = 'gopls'                  -- Use Go language server
vim.g.go_info_mode = 'gopls'
vim.g.go_auto_sameids = 1                    -- Highlight matching names
vim.g.go_code_completion_enabled = 1         -- Enable auto completion
vim.g.go_fmt_fail_silently = 1               -- Save w syntax errors

-- Line number settings
vim.o.number = true         -- Show absolute line number for the current line
vim.o.relativenumber = true -- Show relative line numbers for other lines

-- Tab and indentation settings
vim.opt.tabstop = 4		    -- Number of spaces that a tab counts for
vim.opt.shiftwidth = 4		-- Number of spaces to use for auto-indent
vim.opt.expandtab = true	-- Convert tabs to space

-- Disable code folding on startup
vim.o.foldenable = false    -- Do not enable folding
vim.o.foldlevel = 99        -- Ensure all folds open
vim.o.foldmethod = 'manual' --Set the folding method to 'manual'

-- nvim-treesitter folding settings
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod     = 'expr'
    vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
  end
})

require('transparent').clear_prefix('BufferLine')
