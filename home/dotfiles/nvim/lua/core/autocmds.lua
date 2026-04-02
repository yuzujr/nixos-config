local group = vim.api.nvim_create_augroup("rc_core", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 180 })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = group,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local last = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if last > 1 and last <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, { last, 0 })
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  command = "wincmd =",
})

