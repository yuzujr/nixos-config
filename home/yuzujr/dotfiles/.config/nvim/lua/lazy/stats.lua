local M = {}

-- Compatibility shim for plugins that expect lazy.nvim's stats module.
-- This config uses vim.pack, so we provide a minimal equivalent.
function M.stats()
  local count = 0

  local patterns = {
    "pack/*/start/*",
    "pack/*/opt/*",
  }
  for _, p in ipairs(patterns) do
    count = count + #vim.api.nvim_get_runtime_file(p, true)
  end

  return {
    startuptime = 0,
    loaded = count,
    count = count,
  }
end

return M
