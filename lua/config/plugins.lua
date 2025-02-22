
-- Plugin Manager (Packer :PackerSync)
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'wbthomason/packer.nvim'                  -- Packer plugin manager

  -- Autocompletion features
  use 'hrsh7th/nvim-cmp'                        -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'                    -- LSP source for nvim-cmp
  use 'hrsh7th/vim-vsnip' 		                -- Snippet engine		
  use 'hrsh7th/vim-vsnip-integ'
  use 'neovim/nvim-lspconfig'                   -- LSP configurations

  use 'rafamadriz/friendly-snippets'            -- Friendly snippets
  use {'fatih/vim-go', run = 'GoUpdateBinaries'}-- Go development plugin
  use 'preservim/nerdtree'                      -- File tree
  use 'nvim-lua/plenary.nvim'                   -- Common utilities
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'folke/tokyonight.nvim', lazy = false, priority = 1000, opts = {}, }
  use 'nvim-telescope/telescope.nvim'           -- Fuzzy finder
  use {'akinsho/toggleterm.nvim', tag = '*'}    -- Terminal toggle
  use {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      requires = { {"nvim-lua/plenary.nvim"} }
  }
  -- Bufferline
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  use 'junegunn/goyo.vim'

  use 'psf/black' -- Python Code formatter
  use 'jose-elias-alvarez/null-ls.nvim' -- Linting and formatting plugin
  use 'nikvdp/ejs-syntax'

  use 'mfussenegger/nvim-dap' -- Debug Adapter Protocol for debugging
  use 'Hoffs/omnisharp-extended-lsp.nvim' -- Omnisharp specific helpers
end)

-- Color settings have to be here so plugins load them correctly 
vim.opt.termguicolors = true
-- Enable syntax highlighting and Catppuccin theme
vim.cmd('colorscheme catppuccin')

-- Harpoon config
local harpoon = require("harpoon")
harpoon.setup({})

local conf = require("telescope.config").values

_G.toggle_telescope = function(harpoon_files)
  local file_paths = {}

  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  local make_finder = function()
    local paths = {}

    for _, item in ipairs(harpoon_files.items) do
      table.insert(paths, item.value)
    end

    return require("telescope.finders").new_table({
      results = paths,
    })
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = false,
      sorter = conf.generic_sorter({}),
      layout_strategy = "center",
      layout_config = {
        preview_cutoff = 1,
        width = function(_, max_columns, _)
          return math.min(max_columns, 80)
        end,
        height = function(_, _, max_lines)
          return math.min(max_lines, 15)
        end,
      },
      borderchars = {
        prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
        results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
        preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
      attach_mappings = function(prompt_buffer_number, map)
        map("i", "<c-d>", function()
          local state = require("telescope.actions.state")
          local selected_entry = state.get_selected_entry()
          local current_picker = state.get_current_picker(prompt_buffer_number)

          harpoon:list():remove(selected_entry)
          current_picker:refresh(make_finder())
        end)

        return true
      end,
    })
    :find()
end

-- nvim-treesitter setup
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "lua", "bash", "python", "c_sharp" },  -- Add languages here

  highlight = {
    enable = true,                              -- Enable Tree-Sitter-based highlighting
    additional_vim_regex_highlighting = false,  -- Turn off Vim’s regex-based syntax highlighting
  },
  indent = {
    enable = true,  -- Enable Treesitter-based indentation
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- Toggleterm setup for floating terminal
require("toggleterm").setup{
  size = 16,
  open_mapping = [[<c-\>]],  -- Ctrl+\ to toggle terminal
  direction = 'float',       -- Floating window for terminal
  float_opts = {
    border = 'curved',       -- Curved border for the floating terminal
  }
}

-- Bufferline setup
require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    show_buffer_close_icons = false,
    show_close_icon = false,
    themable = true,
  }
}
