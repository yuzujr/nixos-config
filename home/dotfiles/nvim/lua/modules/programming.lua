local M = {}

local map = require("core.map")

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
      "jsonc",
      "yaml",
      "markdown",
      "markdown_inline",
      "nix",
      "toml",
      "regex",
      "vim",
      "vimdoc",
      "query",
      "htmldjango",
      "gdscript",
      "godot_resource",
      "gdshader",
    },
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })
end

local function setup_conform()
  local ok_conform, conform = pcall(require, "conform")
  if not ok_conform then
    map.set("n", "<leader>cf", function()
      vim.notify("conform.nvim is not available.", vim.log.levels.WARN)
    end, "Format buffer")
    return
  end

  conform.setup({
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 800,
      lsp_fallback = false,
    },
    formatters_by_ft = {
      lua = { "stylua" },
      nix = { "nixfmt" },
      rust = { "rustfmt" },
      python = { "black" },
      go = { "gofmt" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      tsx = { "prettier" },
      jsonc = { "prettier" },
      json = { "jq" },
      css = { "prettier" },
      scss = { "prettier" },
      htmldjango = { "djlint" },
      html = { "djlint" },
      markdown = { "prettier" },
      yaml = { "prettier" },
    },
  })

  local function format_buffer()
    conform.format({ async = true, lsp_fallback = false })
  end

  map.set("n", "<leader>cf", format_buffer, "Format buffer")
  map.set("n", "<leader>lf", format_buffer, "Format buffer")
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

  map.set("n", "]h", gitsigns.next_hunk, "Next hunk")
  map.set("n", "[h", gitsigns.prev_hunk, "Previous hunk")
  map.set("n", "<leader>ghs", gitsigns.stage_hunk, "Stage hunk")
  map.set("n", "<leader>ghr", gitsigns.reset_hunk, "Reset hunk")
  map.set("n", "<leader>ghp", gitsigns.preview_hunk, "Preview hunk")
  map.set("n", "<leader>ghb", gitsigns.blame_line, "Blame line")
  map.set("n", "<leader>ghd", gitsigns.diffthis, "Diff this")
  map.set("n", "<leader>ghq", gitsigns.setqflist, "Hunks to quickfix")
  map.set("n", "<leader>ght", gitsigns.toggle_current_line_blame, "Toggle line blame")
end

function M.setup()
  setup_pairs()
  setup_treesitter()
  setup_conform()
  setup_gitsigns()
end

return M
