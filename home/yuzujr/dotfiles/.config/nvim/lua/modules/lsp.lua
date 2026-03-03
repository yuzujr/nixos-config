local M = {}

local function lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink and type(blink.get_lsp_capabilities) == "function" then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  return capabilities
end

local function on_attach(_, bufnr)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = desc,
    })
  end

  map("n", "gd", vim.lsp.buf.definition, "LSP definition")
  map("n", "gr", vim.lsp.buf.references, "LSP references")
  map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
  map("n", "K", vim.lsp.buf.hover, "LSP hover")
  map("i", "<C-h>", vim.lsp.buf.signature_help, "Signature help")

  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>cD", vim.lsp.buf.declaration, "Declaration")
  map("n", "<leader>cd", vim.lsp.buf.definition, "Definition")
  map("n", "<leader>ci", vim.lsp.buf.implementation, "Implementation")
  map("n", "<leader>cs", vim.lsp.buf.workspace_symbol, "Workspace symbol")

  map("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "Previous diagnostic")
  map("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "Next diagnostic")
  map("n", "<leader>xd", vim.diagnostic.setloclist, "Diagnostics list")
  map("n", "<leader>xx", vim.diagnostic.setloclist, "Diagnostics list")
end

function M.setup()
  local ok_lazydev, lazydev = pcall(require, "lazydev")
  if ok_lazydev then
    lazydev.setup({})
  end

  local ensure_installed = {
    "lua_ls",
    "basedpyright",
    "ts_ls",
    "eslint",
    "clangd",
    "jsonls",
    "bashls",
    "marksman",
  }

  local ok_mason, mason = pcall(require, "mason")
  if ok_mason then
    mason.setup()
  end

  local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
  if ok_mason_lsp then
    mason_lspconfig.setup({ ensure_installed = ensure_installed })
  end

  local capabilities = lsp_capabilities()
  local base = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  local ok_util, lsp_util = pcall(require, "lspconfig.util")
  local py_root = nil
  if ok_util then
    py_root = lsp_util.root_pattern(".git", "setup.py", "pyproject.toml", "requirements.txt")
  end

  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    },
    basedpyright = {
      root_dir = py_root,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            typeCheckingMode = "basic",
          },
        },
      },
    },
    ts_ls = {},
    eslint = {},
    clangd = {},
    jsonls = {},
    bashls = {},
    marksman = {},
    emmet_ls = {
      filetypes = {
        "html",
        "css",
        "javascriptreact",
        "typescriptreact",
        "htmldjango",
        "djangohtml",
      },
    },
  }

  if vim.fn.executable("go") == 1 then
    servers.gopls = {}
  end

  local enabled_servers = {}
  for server, server_cfg in pairs(servers) do
    local cfg = vim.tbl_deep_extend("force", {}, base, server_cfg)
    local ok = pcall(vim.lsp.config, server, cfg)
    if ok then
      table.insert(enabled_servers, server)
    end
  end

  if #enabled_servers > 0 then
    vim.lsp.enable(enabled_servers)
  end

  vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    severity_sort = true,
    update_in_insert = false,
    float = {
      border = "rounded",
      source = "if_many",
    },
  })
end

return M
