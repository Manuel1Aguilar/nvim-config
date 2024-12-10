
-- Autocompletion setup
vim.cmd [[
    let g:vsnip_filetypes = {}
    let g:vsnip_filetypes.go = ['go']
    let g:vsnip_snippet_dir = expand('~/.local/share/nvim/site/pack/packer/start/friendly-snippets/snippets')
]]

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-n>'] = cmp.mapping.select_next_item(), -- Navigate to next item
    ['<C-p>'] = cmp.mapping.select_prev_item(), -- Navigate to previous item
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept completion with Enter
  },
  sources = {
    { name = 'vsnip' },    -- Use vim-vsnip as a snippet completion source
    { name = 'nvim_lsp' }, -- Add the LSP source
    { name = 'buffer' },   -- Buffer completion
  }
})

-- Setup LSP with cmp
local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.default_capabilities()

-- Setup gopls (Go Language Server)
lspconfig.gopls.setup {
  capabilities = capabilities, -- Enable nvim-cmp capabilities
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
-- Setup lua language server
lspconfig.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      -- Use vim.loop instead of vim.uv for file system checks
      if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        return
      end
    end

    -- Merge settings with the default Lua settings
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Use LuaJIT as the runtime (Neovim default)
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false, -- Disable third-party library checks
        library = {
          vim.env.VIMRUNTIME, -- Add Neovim runtime files to the library
          "${3rd}/luv/library",
        },
      },
    })

    -- Reconfigure the language server with updated settings
    client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
  end,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'use' },
      },
    },
  },
}

-- Setup tesserver (for both JS and TS)
lspconfig.ts_ls.setup{
    on_attach = function(_, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = { noremap = true, silent = true }

        buf_set_keymap('n', 'gi', '<Cmd> lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<Cmd> lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', 'gr', '<Cmd> lua vim.lsp.buf.references()<CR>', opts)
    end,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git")
}
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.ejs",
    callback = function()
        vim.bo.filetype = "ejs"
    end,
})

lspconfig.pyright.setup{}

lspconfig.omnisharp.setup({
    cmd = { "dotnet", "C:\\Tools\\omnisharp\\OmniSharp.dll" },
    enable_editorconfig_support = true,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
})
