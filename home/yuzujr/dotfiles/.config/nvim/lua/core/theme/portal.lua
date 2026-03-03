local M = {}

local monitor_job

local function scheme_to_bg(u32)
  if u32 == 1 then
    return "dark"
  end
  if u32 == 2 then
    return "light"
  end
  return nil
end

local function apply(bg)
  if not bg then
    return
  end
  if vim.o.background == bg and vim.g.colors_name == "solarized" then
    return
  end

  vim.o.termguicolors = true
  vim.o.background = bg
  pcall(vim.cmd.colorscheme, "solarized")
end

local function read_scheme_once()
  local out = vim.fn.system({
    "gdbus",
    "call",
    "--session",
    "--dest",
    "org.freedesktop.portal.Desktop",
    "--object-path",
    "/org/freedesktop/portal/desktop",
    "--method",
    "org.freedesktop.portal.Settings.Read",
    "org.freedesktop.appearance",
    "color-scheme",
  })

  local value = tonumber(out:match("uint32%s*(%d+)"))
  apply(scheme_to_bg(value))
end

function M.setup()
  if vim.fn.executable("gdbus") ~= 1 then
    return
  end

  read_scheme_once()

  monitor_job = vim.fn.jobstart({
    "gdbus",
    "monitor",
    "--session",
    "--dest",
    "org.freedesktop.portal.Desktop",
    "--object-path",
    "/org/freedesktop/portal/desktop",
  }, {
    stdout_buffered = false,
    on_stdout = function(_, data)
      if not data then
        return
      end

      for _, line in ipairs(data) do
        if line
          and line:find("SettingChanged", 1, true)
          and line:find("org.freedesktop.appearance", 1, true)
          and line:find("color-scheme", 1, true)
        then
          local value = tonumber(line:match("<uint32%s+(%d+)>") or "")
          apply(scheme_to_bg(value))
        end
      end
    end,
  })

  if monitor_job and monitor_job > 0 then
    local group = vim.api.nvim_create_augroup("rc_theme_portal", { clear = true })
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = group,
      callback = function()
        pcall(vim.fn.jobstop, monitor_job)
      end,
    })
  end
end

return M
