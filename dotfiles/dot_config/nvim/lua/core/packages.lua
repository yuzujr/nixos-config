local M = {}

local specs = {
  -- Core UX
  { src = "https://github.com/maxmx03/solarized.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },

  -- Completion
  { src = "https://github.com/Saghen/blink.cmp", version = "v1.*" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },

  -- LSP / Formatting
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },

  -- Syntax / Git
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/tpope/vim-sleuth" },
  { src = "https://github.com/echasnovski/mini.pairs" },
}

function M.setup()
  if not vim.pack or type(vim.pack.add) ~= "function" then
    vim.notify("This configuration requires Neovim 0.12+ (vim.pack).", vim.log.levels.ERROR)
    return
  end

  vim.pack.add(specs)
end

return M
