local M = {}
local map = require("core.map")

local function open_cheatsheet()
  local path = vim.fn.stdpath("config") .. "/CHEATSHEET.md"
  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.bo.modifiable = false
  vim.bo.readonly = true
end

function M.setup()
  vim.api.nvim_create_user_command("Cheatsheet", open_cheatsheet, {
    desc = "Open the Neovim cheatsheet",
  })

  map.set("n", "<leader>?", open_cheatsheet, "Open cheatsheet")
end

return M
