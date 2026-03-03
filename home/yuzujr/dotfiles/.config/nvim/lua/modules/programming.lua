local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function setup_pairs()
  local ok_pairs, mini_pairs = pcall(require, "mini.pairs")
  if not ok_pairs then
    return
  end

  mini_pairs.setup({})
end

local function setup_treesitter()
  local ok_treesitter, treesitter = pcall(require, "nvim-treesitter.configs")
  if not ok_treesitter then
    return
  end

  treesitter.setup({
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "go",
      "lua",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
      "vim",
      "vimdoc",
      "query",
      "htmldjango",
      "gdscript",
      "godot_resource",
      "gdshader",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  })
end

local function setup_conform()
  local ok_conform, conform = pcall(require, "conform")
  if not ok_conform then
    map("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
    return
  end

  conform.setup({
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 800,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      python = { "black" },
      go = { "gofmt" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "jq" },
      htmldjango = { "djlint" },
      html = { "djlint" },
      markdown = { "prettier" },
      yaml = { "prettier" },
    },
  })

  local function format_buffer()
    conform.format({ async = true, lsp_fallback = true })
  end

  map("n", "<leader>cf", format_buffer, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
  map("n", "<leader>lf", format_buffer, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
end

local function setup_gitsigns()
  local ok_gitsigns, gitsigns = pcall(require, "gitsigns")
  if not ok_gitsigns then
    return
  end

  gitsigns.setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "-" },
      changedelete = { text = "~" },
      untracked = { text = "|" },
    },
    current_line_blame = false,
  })

  map("n", "]h", gitsigns.next_hunk, vim.tbl_extend("force", opts, { desc = "Next hunk" }))
  map("n", "[h", gitsigns.prev_hunk, vim.tbl_extend("force", opts, { desc = "Prev hunk" }))
  map("n", "<leader>ghs", gitsigns.stage_hunk, vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
  map("n", "<leader>ghr", gitsigns.reset_hunk, vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
  map("n", "<leader>ghp", gitsigns.preview_hunk, vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
  map("n", "<leader>ghb", gitsigns.blame_line, vim.tbl_extend("force", opts, { desc = "Blame line" }))
end

function M.setup()
  setup_pairs()
  setup_treesitter()
  setup_conform()
  setup_gitsigns()
end

return M
