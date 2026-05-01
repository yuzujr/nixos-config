local M = {}

local function with_defaults(desc, extra)
  local opts = vim.tbl_extend("force", { silent = true }, extra or {})
  if desc then
    opts.desc = desc
  end
  return opts
end

function M.set(mode, lhs, rhs, desc, extra)
  vim.keymap.set(mode, lhs, rhs, with_defaults(desc, extra))
end

function M.buf(bufnr, mode, lhs, rhs, desc, extra)
  local opts = vim.tbl_extend("force", { buffer = bufnr }, extra or {})
  vim.keymap.set(mode, lhs, rhs, with_defaults(desc, opts))
end

function M.opts(desc, extra)
  return with_defaults(desc, extra)
end

return M
