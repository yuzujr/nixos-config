local M = {}

local function setup_colorscheme()
  local ok, solarized = pcall(require, "solarized")
  if not ok then
    vim.notify("solarized.nvim is not installed yet.", vim.log.levels.WARN)
    return
  end

  solarized.setup({})
  pcall(vim.cmd.colorscheme, "solarized")
  require("core.theme.portal").setup()
end

local function setup_messages_ui()
  local map = require("core.map")
  local ok_notify, notify = pcall(require, "notify")
  if ok_notify then
    notify.setup({
      render = "compact",
      stages = "fade_in_slide_out",
      timeout = 2600,
    })
    vim.notify = notify
  end

  local ok_noice, noice = pcall(require, "noice")
  if not ok_noice then
    return
  end

  noice.setup({
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
    },
    popupmenu = {
      enabled = true,
      backend = "nui",
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    messages = {
      enabled = true,
      view = "notify",
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
    },
    routes = {
      {
        filter = { event = "notify", find = "No information available" },
        opts = { skip = true },
      },
    },
  })

  map.set("n", "<leader>fn", "<cmd>Noice history<cr>", "Notification history")
  map.set("n", "<leader>un", "<cmd>Noice dismiss<cr>", "Dismiss notifications")
end

local function setup_lualine()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  local function lsp_status()
    local status = vim.lsp.status()
    return status ~= "" and status or nil
  end

  lualine.setup({
    options = {
      theme = "auto",
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      },
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = {
            modified = " [+]",
            readonly = " [RO]",
            unnamed = "[No Name]",
          },
        },
      },
      lualine_x = {
        { lsp_status, color = { gui = "italic" } },
        "diagnostics",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
    },
  })
end

function M.setup()
  setup_colorscheme()
  setup_messages_ui()
  setup_lualine()
end

return M
