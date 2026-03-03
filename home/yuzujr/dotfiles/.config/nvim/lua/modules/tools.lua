local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function snacks_call(fn)
  return function()
    local ok, snacks = pcall(require, "snacks")
    if not ok then
      vim.notify("snacks.nvim is not available.", vim.log.levels.WARN)
      return
    end

    local ok_fn, err = pcall(fn, snacks)
    if not ok_fn then
      vim.notify(("Snacks error: %s"):format(err), vim.log.levels.ERROR)
    end
  end
end

local function setup_which_key()
  local ok, which_key = pcall(require, "which-key")
  if not ok then
    return
  end

  local ok_setup = pcall(which_key.setup, {
    preset = "helix",
    delay = 300,
    notify = false,
    plugins = {
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
      wo = {
        winblend = 0,
      },
    },
    layout = {
      width = { min = 28 },
      spacing = 4,
    },
    icons = {
      mappings = true,
      colors = true,
    },
  })

  if not ok_setup then
    which_key.setup({ delay = 300 })
  end

  pcall(which_key.add, {
    { "<leader><space>", desc = "Smart Find" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>j", group = "Jump" },
    { "<leader>c", group = "Code" },
    { "<leader>b", group = "Buffer" },
    { "<leader>w", group = "Window" },
    { "<leader>x", group = "Quickfix" },
    { "<leader>u", group = "UI" },
    { "<leader>a", group = "AI" },
    { "<leader>t", group = "Terminal" },
  })
end

local function setup_snacks()
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    return
  end

  snacks.setup({
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
      },
    },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = false },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    words = { enabled = true },
  })

  map("n", "<leader><space>", snacks_call(function(S)
    S.picker.smart()
  end), vim.tbl_extend("force", opts, { desc = "Smart find" }))

  map("n", "<leader>ff", snacks_call(function(S)
    S.picker.files()
  end), vim.tbl_extend("force", opts, { desc = "Find files" }))

  map("n", "<leader>fr", snacks_call(function(S)
    S.picker.recent()
  end), vim.tbl_extend("force", opts, { desc = "Recent files" }))

  map("n", "<leader>fb", snacks_call(function(S)
    S.picker.buffers()
  end), vim.tbl_extend("force", opts, { desc = "Buffers" }))

  map("n", "<leader>fh", snacks_call(function(S)
    S.picker.help()
  end), vim.tbl_extend("force", opts, { desc = "Help tags" }))

  map("n", "<leader>fk", snacks_call(function(S)
    S.picker.keymaps()
  end), vim.tbl_extend("force", opts, { desc = "Keymaps" }))

  map("n", "<leader>fd", snacks_call(function(S)
    S.picker.diagnostics()
  end), vim.tbl_extend("force", opts, { desc = "Diagnostics" }))

  map("n", "<leader>f/", snacks_call(function(S)
    S.picker.resume()
  end), vim.tbl_extend("force", opts, { desc = "Resume picker" }))

  map("n", "<leader>fe", snacks_call(function(S)
    S.explorer.open()
  end), vim.tbl_extend("force", opts, { desc = "Explorer" }))

  map("n", "<leader>fE", snacks_call(function(S)
    S.explorer.reveal()
  end), vim.tbl_extend("force", opts, { desc = "Reveal file in explorer" }))

  map("n", "<leader>gg", snacks_call(function(S)
    S.picker.git_status()
  end), vim.tbl_extend("force", opts, { desc = "Git status" }))

  map("n", "<leader>gb", snacks_call(function(S)
    S.git.blame_line()
  end), vim.tbl_extend("force", opts, { desc = "Git blame line" }))

  map("n", "<leader>e", snacks_call(function(S)
    S.explorer.open()
  end), vim.tbl_extend("force", opts, { desc = "Explorer" }))

  map("n", "<C-n>", snacks_call(function(S)
    S.explorer.open()
  end), vim.tbl_extend("force", opts, { desc = "Explorer" }))

  map("n", "<leader>tt", snacks_call(function(S)
    S.terminal.toggle()
  end), vim.tbl_extend("force", opts, { desc = "Terminal" }))
end

function M.setup()
  setup_which_key()
  setup_snacks()
end

return M
