local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local state = {
  buf = nil,
  chan = nil,
}

local function context_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= "" then
    return vim.fs.dirname(vim.fs.normalize(name))
  end

  local cwd = (vim.uv and vim.uv.cwd()) or vim.fn.getcwd()
  return vim.fs.normalize(cwd)
end

local function project_root()
  local start = context_path()
  local marker = vim.fs.find({ ".git", "AGENTS.md" }, {
    upward = true,
    path = start,
  })[1]

  if marker then
    return vim.fs.dirname(marker)
  end

  return start
end

local function job_running(chan)
  if not chan or chan <= 0 then
    return false
  end

  local ok, ret = pcall(vim.fn.jobwait, { chan }, 0)
  return ok and ret and ret[1] == -1
end

local function scan_existing_session()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].rc_ai_terminal then
      local chan = vim.b[buf].terminal_job_id or vim.b[buf].rc_ai_chan
      if job_running(chan) then
        state.buf = buf
        state.chan = chan
        return true
      end
    end
  end
  return false
end

local function have_live_session()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) and job_running(state.chan) then
    return true
  end
  return scan_existing_session()
end

local function focus_buffer(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
      return
    end
  end

  vim.cmd("botright vsplit")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, 72)
  vim.api.nvim_win_set_buf(win, buf)
  vim.cmd("startinsert")
end

local function open_terminal(command)
  vim.cmd("botright vsplit")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, 72)

  vim.cmd("enew")
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].filetype = "terminal"
  vim.b[buf].rc_ai_terminal = true

  local chan = vim.fn.termopen(command, { cwd = project_root() })
  vim.b[buf].rc_ai_chan = chan
  state.buf = buf
  state.chan = chan

  vim.cmd("startinsert")
end

local function open_codex_existing_or_new()
  if vim.fn.executable("codex") ~= 1 then
    vim.notify("codex CLI not found in PATH.", vim.log.levels.WARN)
    return
  end

  if have_live_session() then
    focus_buffer(state.buf)
    return
  end

  open_terminal("codex")
end

local function open_codex_new()
  if vim.fn.executable("codex") ~= 1 then
    vim.notify("codex CLI not found in PATH.", vim.log.levels.WARN)
    return
  end

  open_terminal("codex")
end

local function open_codex_resume_picker()
  if vim.fn.executable("codex") ~= 1 then
    vim.notify("codex CLI not found in PATH.", vim.log.levels.WARN)
    return
  end

  if have_live_session() then
    focus_buffer(state.buf)
    return
  end

  open_terminal("codex resume")
end

local function hide_codex_windows()
  local hidden = false

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.b[buf].rc_ai_terminal then
      pcall(vim.api.nvim_win_close, win, true)
      hidden = true
    end
  end

  if not hidden then
    vim.notify("No AI terminal window to hide.", vim.log.levels.INFO)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("AICodex", function()
    open_codex_existing_or_new()
  end, { desc = "Open or focus Codex session" })

  vim.api.nvim_create_user_command("AICodexNew", function()
    open_codex_new()
  end, { desc = "Open new Codex session" })

  vim.api.nvim_create_user_command("AICodexResume", function()
    open_codex_resume_picker()
  end, { desc = "Resume Codex session (picker if needed)" })

  vim.api.nvim_create_user_command("AICodexHide", function()
    hide_codex_windows()
  end, { desc = "Hide Codex windows" })

  map("n", "<leader>ar", "<cmd>AICodex<cr>", vim.tbl_extend("force", opts, { desc = "AI: Return to session" }))
  map("n", "<leader>an", "<cmd>AICodexNew<cr>", vim.tbl_extend("force", opts, { desc = "AI: New session" }))
  map("n", "<leader>aR", "<cmd>AICodexResume<cr>", vim.tbl_extend("force", opts, { desc = "AI: Resume picker" }))
  map("n", "<leader>ah", "<cmd>AICodexHide<cr>", vim.tbl_extend("force", opts, { desc = "AI: Hide" }))

  -- Backward-compatible alias
  map("n", "<leader>aa", "<cmd>AICodex<cr>", vim.tbl_extend("force", opts, { desc = "AI: Codex (open/focus)" }))
end

return M
