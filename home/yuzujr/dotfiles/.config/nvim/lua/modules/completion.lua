local M = {}

function M.setup()
  local ok_loader, vscode_loader = pcall(require, "luasnip.loaders.from_vscode")
  if ok_loader then
    vscode_loader.lazy_load()
  end

  local ok, blink = pcall(require, "blink.cmp")
  if not ok then
    return
  end

  blink.setup({
    keymap = { preset = "super-tab" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      accept = {
        auto_brackets = {
          enabled = true,
          kind_resolution = { enabled = true },
          semantic_token_resolution = { enabled = true },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 120,
      },
      ghost_text = {
        enabled = true,
      },
    },
    snippets = {
      preset = "luasnip",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = {
      -- Stable on systems without cargo/prebuilt fuzzy library.
      implementation = "lua",
    },
    signature = {
      enabled = true,
    },
  })
end

return M
