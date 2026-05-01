local M = {}

local map = require("core.map")

local function lsp_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok and type(blink.get_lsp_capabilities) == "function" then
    return blink.get_lsp_capabilities()
  end
  return vim.lsp.protocol.make_client_capabilities()
end

local function picker_or(method, fallback)
  return function()
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.picker and snacks.picker[method] then
      return snacks.picker[method]()
    end
    return fallback()
  end
end

local function workspace_symbols()
  local query = vim.fn.input("Workspace symbol: ")
  if query == "" then
    return
  end
  vim.lsp.buf.workspace_symbol(query)
end

local function setup_diagnostics()
  local severity = vim.diagnostic.severity

  vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = {
      source = "if_many",
      spacing = 2,
    },
    float = {
      border = "rounded",
      source = "if_many",
    },
    signs = {
      text = {
        [severity.ERROR] = "E",
        [severity.WARN] = "W",
        [severity.INFO] = "I",
        [severity.HINT] = "H",
      },
    },
  })
end

local function setup_servers()
  local servers = {
    lua_ls = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          diagnostics = {
            globals = { "vim" },
          },
          hint = {
            enable = true,
          },
          telemetry = {
            enable = false,
          },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },
    nixd = {
      cmd = { "nixd" },
      filetypes = { "nix" },
      root_markers = { "flake.nix", "default.nix", ".git" },
      settings = {
        nixd = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    },
    basedpyright = {
      cmd = { "basedpyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    },
    pyright = {
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    },
    ts_ls = {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
      root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    },
    clangd = {
      cmd = { "clangd", "--background-index", "--clang-tidy" },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
      init_options = {
        clangdFileStatus = true,
      },
    },
    gopls = {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.work", "go.mod", ".git" },
      settings = {
        gopls = {
          gofumpt = true,
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            parameterNames = true,
          },
          staticcheck = true,
          usePlaceholders = true,
        },
      },
    },
    rust_analyzer = {
      cmd = { "rust-analyzer" },
      filetypes = { "rust" },
      root_markers = { "Cargo.toml", "rust-project.json", ".git" },
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          checkOnSave = true,
          procMacro = {
            enable = true,
          },
        },
      },
    },
    bashls = {
      cmd = { "bash-language-server", "start" },
      filetypes = { "bash", "sh", "zsh" },
      root_markers = { ".git" },
    },
    jsonls = {
      cmd = { "vscode-json-language-server", "--stdio" },
      filetypes = { "json", "jsonc" },
      root_markers = { ".git", "package.json" },
    },
    yamlls = {
      cmd = { "yaml-language-server", "--stdio" },
      filetypes = { "yaml" },
      root_markers = { ".git", "package.json" },
    },
    marksman = {
      cmd = { "marksman", "server" },
      filetypes = { "markdown" },
      root_markers = { ".git" },
    },
  }

  local groups = {
    { "lua_ls" },
    { "nixd" },
    { "basedpyright", "pyright" },
    { "ts_ls" },
    { "clangd" },
    { "gopls" },
    { "rust_analyzer" },
    { "bashls" },
    { "jsonls" },
    { "yamlls" },
    { "marksman" },
  }

  vim.lsp.config("*", {
    capabilities = lsp_capabilities(),
    root_markers = { ".git" },
  })

  for _, group in ipairs(groups) do
    for _, name in ipairs(group) do
      local config = servers[name]
      if vim.fn.executable(config.cmd[1]) == 1 then
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
        break
      end
    end
  end
end

local function setup_attach()
  local group = vim.api.nvim_create_augroup("rc_lsp_attach", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      map.buf(bufnr, "n", "gd", picker_or("lsp_definitions", vim.lsp.buf.definition), "Go to definition")
      map.buf(bufnr, "n", "gD", picker_or("lsp_declarations", vim.lsp.buf.declaration), "Go to declaration")
      map.buf(bufnr, "n", "gr", picker_or("lsp_references", vim.lsp.buf.references), "References", { nowait = true })
      map.buf(bufnr, "n", "gI", picker_or("lsp_implementations", vim.lsp.buf.implementation), "Go to implementation")
      map.buf(bufnr, "n", "gy", picker_or("lsp_type_definitions", vim.lsp.buf.type_definition), "Go to type definition")
      map.buf(bufnr, "n", "K", vim.lsp.buf.hover, "Hover")
      map.buf(bufnr, "i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

      map.buf(bufnr, { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
      map.buf(bufnr, "n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
      map.buf(bufnr, "n", "<leader>cd", picker_or("lsp_definitions", vim.lsp.buf.definition), "Definition")
      map.buf(bufnr, "n", "<leader>cD", picker_or("lsp_declarations", vim.lsp.buf.declaration), "Declaration")
      map.buf(bufnr, "n", "<leader>ci", picker_or("lsp_implementations", vim.lsp.buf.implementation), "Implementation")
      map.buf(bufnr, "n", "<leader>ct", picker_or("lsp_type_definitions", vim.lsp.buf.type_definition), "Type definition")
      map.buf(bufnr, "n", "<leader>cs", picker_or("lsp_symbols", vim.lsp.buf.document_symbol), "Document symbols")
      map.buf(bufnr, "n", "<leader>cS", picker_or("lsp_workspace_symbols", workspace_symbols), "Workspace symbols")

      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_group = vim.api.nvim_create_augroup(("rc_lsp_highlight_%d"):format(bufnr), { clear = true })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          group = highlight_group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
          group = highlight_group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end

      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
  })
end

function M.setup()
  setup_diagnostics()
  setup_servers()
  setup_attach()
end

return M
