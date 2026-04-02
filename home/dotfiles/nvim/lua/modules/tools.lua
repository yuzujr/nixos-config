local M = {}

local map = require("core.map")

local function explorer_open(snacks)
  if type(snacks.explorer) == "table" and type(snacks.explorer.open) == "function" then
    return snacks.explorer.open()
  end
  if type(snacks.explorer) == "function" then
    return snacks.explorer()
  end
end

local function explorer_reveal(snacks)
  if type(snacks.explorer) == "table" and type(snacks.explorer.reveal) == "function" then
    return snacks.explorer.reveal()
  end
  return explorer_open(snacks)
end

local function run(desc, fn)
  return function()
    local ok, err = pcall(fn)
    if not ok then
      vim.notify(("%s failed: %s"):format(desc, err), vim.log.levels.WARN)
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
    { "<leader>p", group = "Packages" },
    { "<leader>t", group = "Terminal" },
  })
end

local function setup_toggles(snacks)
  if not snacks.toggle then
    return
  end

  snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  snacks.toggle.line_number():map("<leader>ul")
  snacks.toggle.diagnostics():map("<leader>ud")
  snacks.toggle.inlay_hints():map("<leader>uh")
  snacks.toggle.treesitter():map("<leader>uT")
  snacks.toggle.indent():map("<leader>ug")
  snacks.toggle.dim():map("<leader>uD")
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
      preset = {
        header = [[
 _   _ __     ___ __  __
| \ | |\ \   / / |  \/  |
|  \| | \ \ / /| | |\/| |
| |\  |  \ V / | | |  | |
|_| \_|   \_/  |_|_|  |_|
        ]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
      },
    },
    explorer = { enabled = true },
    dim = { enabled = true },
    gitbrowse = { enabled = true },
    indent = { enabled = false },
    input = { enabled = true },
    notifier = { enabled = false },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scratch = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
  })

  setup_toggles(snacks)

  map.set("n", "<leader><space>", run("Smart find", function()
    snacks.picker.smart()
  end), "Smart find")
  map.set("n", "<leader>ff", run("Find files", function()
    snacks.picker.files()
  end), "Find files")
  map.set("n", "<leader>fG", run("Git files", function()
    snacks.picker.git_files()
  end), "Git files")
  map.set("n", "<leader>fg", run("Grep", function()
    snacks.picker.grep()
  end), "Grep")
  map.set("n", "<leader>fr", run("Recent files", function()
    snacks.picker.recent()
  end), "Recent files")
  map.set("n", "<leader>fb", run("Buffers", function()
    snacks.picker.buffers()
  end), "Buffers")
  map.set("n", "<leader>fh", run("Help tags", function()
    snacks.picker.help()
  end), "Help tags")
  map.set("n", "<leader>fk", run("Keymaps", function()
    snacks.picker.keymaps()
  end), "Keymaps")
  map.set("n", "<leader>fd", run("Diagnostics", function()
    snacks.picker.diagnostics()
  end), "Diagnostics")
  map.set("n", "<leader>fD", run("Buffer diagnostics", function()
    snacks.picker.diagnostics_buffer()
  end), "Buffer diagnostics")
  map.set("n", "<leader>f/", run("Resume picker", function()
    snacks.picker.resume()
  end), "Resume picker")
  map.set("n", "<leader>fo", run("Edit config", function()
    snacks.picker.files({ cwd = vim.fn.stdpath("config") })
  end), "Edit config")
  map.set("n", "<leader>fe", run("Explorer", function()
    explorer_open(snacks)
  end), "Explorer")
  map.set("n", "<leader>fE", run("Reveal file in explorer", function()
    explorer_reveal(snacks)
  end), "Reveal file in explorer")

  map.set("n", "<leader>gg", run("Git status", function()
    snacks.picker.git_status()
  end), "Git status")
  map.set("n", "<leader>gb", run("Git blame line", function()
    snacks.git.blame_line()
  end), "Git blame line")
  map.set({ "n", "x" }, "<leader>gB", run("Git browse", function()
    snacks.gitbrowse()
  end), "Git browse")

  map.set("n", "<leader>bd", run("Delete buffer", function()
    snacks.bufdelete()
  end), "Delete buffer")
  map.set("n", "<leader>cR", run("Rename file", function()
    snacks.rename.rename_file()
  end), "Rename file")
  map.set("n", "<leader>z", run("Zen mode", function()
    snacks.zen()
  end), "Zen mode")
  map.set("n", "<leader>.", run("Scratch buffer", function()
    snacks.scratch()
  end), "Scratch buffer")
  map.set("n", "<leader>S", run("Scratch buffers", function()
    snacks.scratch.select()
  end), "Scratch buffers")
  map.set("n", "<leader>e", run("Explorer", function()
    explorer_open(snacks)
  end), "Explorer")
  map.set("n", "<C-n>", run("Explorer", function()
    explorer_open(snacks)
  end), "Explorer")
  map.set("n", "<leader>tt", run("Terminal", function()
    snacks.terminal()
  end), "Terminal")
  map.set({ "n", "t" }, "]]", run("Next reference", function()
    snacks.words.jump(vim.v.count1)
  end), "Next reference")
  map.set({ "n", "t" }, "[[", run("Previous reference", function()
    snacks.words.jump(-vim.v.count1)
  end), "Previous reference")
  map.set("n", "<leader>N", run("Neovim news", function()
    snacks.win({
      file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
      width = 0.6,
      height = 0.6,
      wo = {
        conceallevel = 3,
        signcolumn = "yes",
        spell = false,
        statuscolumn = " ",
        wrap = false,
      },
    })
  end), "Neovim news")

  map.set("n", "<leader>pu", "<cmd>PackUpdate<cr>", "Update plugins")
  map.set("n", "<leader>ps", "<cmd>PackSync<cr>", "Sync plugins to lockfile")
  map.set("n", "<leader>pp", "<cmd>PackStatus<cr>", "Plugin status")
  map.set("n", "<leader>pd", "<cmd>PackPrune<cr>", "Prune inactive plugins")
end

function M.setup()
  setup_which_key()
  setup_snacks()
end

return M
