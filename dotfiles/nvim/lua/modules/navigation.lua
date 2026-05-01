local M = {}

local map = require("core.map")

function M.setup()
  local ok, flash = pcall(require, "flash")
  if not ok then
    return
  end

  flash.setup({})

  map.set("n", "<leader>jj", function()
    flash.jump()
  end, "Jump")

  map.set("n", "<leader>jt", function()
    flash.treesitter()
  end, "Jump treesitter")

  map.set("n", "<leader>jr", function()
    flash.remote()
  end, "Remote jump")

  map.set("n", "<leader>js", function()
    flash.treesitter_search()
  end, "Treesitter search jump")
end

return M
