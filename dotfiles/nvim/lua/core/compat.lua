local M = {}

local function patch_vim_highlights_query()
  local ok = pcall(vim.treesitter.query.get, "vim", "highlights")
  if ok then
    return
  end

  local query_files = vim.api.nvim_get_runtime_file("queries/vim/highlights.scm", true)
  local runtime_query = query_files[#query_files]
  if not runtime_query then
    vim.notify("Failed to read vim highlights query for compatibility patch.", vim.log.levels.WARN)
    pcall(vim.treesitter.query.set, "vim", "highlights", "")
    return
  end

  local ok_read, lines = pcall(vim.fn.readfile, runtime_query)
  if not ok_read or not lines or #lines == 0 then
    vim.notify("Failed to read vim highlights query for compatibility patch.", vim.log.levels.WARN)
    pcall(vim.treesitter.query.set, "vim", "highlights", "")
    return
  end

  local query = table.concat(lines, "\n")
  query = query:gsub('\n%s*"tab"%s*\n', "\n")

  local ok_set = pcall(vim.treesitter.query.set, "vim", "highlights", query)
  if not ok_set then
    vim.notify("Failed to patch vim treesitter highlights query.", vim.log.levels.WARN)
    pcall(vim.treesitter.query.set, "vim", "highlights", "")
  end
end

function M.setup()
  patch_vim_highlights_query()
end

return M
