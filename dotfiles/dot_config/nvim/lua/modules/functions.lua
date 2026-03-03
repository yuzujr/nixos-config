local M = {}

local function open_cheatsheet()
  local path = vim.fn.stdpath("config") .. "/CHEATSHEET.md"
  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.bo.modifiable = false
  vim.bo.readonly = true
end

function M.setup()
  vim.keymap.set("n", "<leader>?", open_cheatsheet, {
    noremap = true,
    silent = true,
    desc = "Open cheatsheet",
  })
end

return M
