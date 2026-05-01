local M = {}

function M.capabilities(base)
  local ok, blink = pcall(require, "blink.cmp")
  if ok and type(blink.get_lsp_capabilities) == "function" then
    return blink.get_lsp_capabilities(base)
  end
  return base or vim.lsp.protocol.make_client_capabilities()
end

function M.setup()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then
    return
  end

  blink.setup({
    keymap = {
      preset = "default",
      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      keyword = { range = "full" },
      list = {
        selection = {
          auto_insert = false,
          preselect = false,
        },
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
        auto_show_delay_ms = 180,
      },
      ghost_text = {
        enabled = true,
      },
    },
    snippets = {
      preset = "default",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = {
      -- Stable on systems without cargo/prebuilt fuzzy library.
      implementation = "lua",
    },
    signature = { enabled = true },
  })
end

return M
