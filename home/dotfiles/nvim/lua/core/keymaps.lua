local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local function set_wrap()
  vim.opt.wrap = true
  vim.opt.linebreak = true
  map("n", "j", "gj", opts)
  map("n", "k", "gk", opts)
end

local function set_nowrap()
  vim.opt.wrap = false
  vim.opt.linebreak = false
  map("n", "j", "j", opts)
  map("n", "k", "k", opts)
end

map("v", ">", ">gv", opts)
map("v", "<", "<gv", opts)

map("n", "Y", "yy", opts)
map("v", "<C-c>", '"+y', opts)
map("n", "<C-c>", function()
  vim.fn.setreg("+", vim.fn.getline("."))
end, opts)

map("n", "<leader>w", set_wrap, vim.tbl_extend("force", opts, { desc = "Wrap lines" }))
map("n", "<leader>W", set_nowrap, vim.tbl_extend("force", opts, { desc = "Unwrap lines" }))

map("n", "<leader>x", "<cmd>cclose<cr>", vim.tbl_extend("force", opts, { desc = "Close quickfix" }))
map("n", "<leader>sn", "<cmd>cnext<cr>", vim.tbl_extend("force", opts, { desc = "Quickfix next" }))
map("n", "<leader>sp", "<cmd>cprev<cr>", vim.tbl_extend("force", opts, { desc = "Quickfix previous" }))

map("n", "<leader>ge", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
map("n", "<leader>gE", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))

map("n", "<C-h>", "<C-w>h", vim.tbl_extend("force", opts, { desc = "Window left" }))
map("n", "<C-j>", "<C-w>j", vim.tbl_extend("force", opts, { desc = "Window down" }))
map("n", "<C-k>", "<C-w>k", vim.tbl_extend("force", opts, { desc = "Window up" }))
map("n", "<C-l>", "<C-w>l", vim.tbl_extend("force", opts, { desc = "Window right" }))
map("n", "<leader>wH", "<C-w>H", vim.tbl_extend("force", opts, { desc = "Move window far left" }))
map("n", "<leader>wL", "<C-w>L", vim.tbl_extend("force", opts, { desc = "Move window far right" }))

map("n", "gt", "<cmd>bnext<cr>", opts)
map("n", "gT", "<cmd>bprevious<cr>", opts)

-- Terminal mode ergonomics
map("t", "<Esc><Esc>", "<C-\\><C-n>", vim.tbl_extend("force", opts, { desc = "Terminal normal mode" }))
map("t", "<C-h>", "<C-\\><C-n><C-w>h", vim.tbl_extend("force", opts, { desc = "Terminal window left" }))
map("t", "<C-j>", "<C-\\><C-n><C-w>j", vim.tbl_extend("force", opts, { desc = "Terminal window down" }))
map("t", "<C-k>", "<C-\\><C-n><C-w>k", vim.tbl_extend("force", opts, { desc = "Terminal window up" }))
map("t", "<C-l>", "<C-\\><C-n><C-w>l", vim.tbl_extend("force", opts, { desc = "Terminal window right" }))
