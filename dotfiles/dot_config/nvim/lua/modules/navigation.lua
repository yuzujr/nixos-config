local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

function M.setup()
  local ok, flash = pcall(require, "flash")
  if not ok then
    return
  end

  flash.setup({})

  map("n", "<leader>jj", function()
    flash.jump()
  end, vim.tbl_extend("force", opts, { desc = "Jump" }))

  map("n", "<leader>jt", function()
    flash.treesitter()
  end, vim.tbl_extend("force", opts, { desc = "Jump treesitter" }))

  map("n", "<leader>jr", function()
    flash.remote()
  end, vim.tbl_extend("force", opts, { desc = "Remote jump" }))

  map("n", "<leader>js", function()
    flash.treesitter_search()
  end, vim.tbl_extend("force", opts, { desc = "Treesitter search jump" }))
end

return M
