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
  { src = "https://github.com/Saghen/blink.cmp" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },

  -- Formatting
  { src = "https://github.com/stevearc/conform.nvim" },

  -- Syntax / Git
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/rust-lang/rust.vim" },
  { src = "https://github.com/tpope/vim-sleuth" },
  { src = "https://github.com/echasnovski/mini.pairs" },
}

local function setup_commands()
  if vim.g.rc_pack_commands then
    return
  end

  vim.g.rc_pack_commands = true

  vim.api.nvim_create_user_command("PackStatus", function()
    vim.pack.update(nil, { offline = true })
  end, { desc = "Inspect vim.pack plugin state" })

  vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
  end, { desc = "Review plugin updates" })

  vim.api.nvim_create_user_command("PackSync", function()
    vim.pack.update(nil, { target = "lockfile" })
  end, { desc = "Sync plugins to the lockfile" })

  vim.api.nvim_create_user_command("PackPrune", function()
    local inactive = vim
      .iter(vim.pack.get())
      :filter(function(plugin)
        return not plugin.active
      end)
      :map(function(plugin)
        return plugin.spec.name
      end)
      :totable()

    if #inactive == 0 then
      vim.notify("No inactive plugins to prune.", vim.log.levels.INFO)
      return
    end

    vim.pack.del(inactive)
  end, { desc = "Remove inactive vim.pack plugins from disk" })
end

function M.setup()
  if not vim.pack or type(vim.pack.add) ~= "function" then
    vim.notify("This configuration requires Neovim 0.12+ (vim.pack).", vim.log.levels.ERROR)
    return
  end

  vim.pack.add(specs)
  setup_commands()
end

return M
