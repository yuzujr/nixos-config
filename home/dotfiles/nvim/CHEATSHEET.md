# Neovim Cheatsheet

Leader key: `<Space>`

This config is native-first: `vim.pack` manages plugins, native `vim.lsp` manages LSP, and language servers only attach when their executable exists in `PATH`.

## Find / Explorer (Snacks)

- `<leader><space>`: smart find
- `<leader>ff`: files
- `<leader>fG`: git files
- `<leader>fg`: grep
- `<leader>fr`: recent files
- `<leader>fb`: buffers
- `<leader>fh`: help tags
- `<leader>fk`: keymaps
- `<leader>fd`: diagnostics picker
- `<leader>fD`: current-buffer diagnostics
- `<leader>f/`: resume previous picker
- `<leader>fo`: edit Neovim config
- `<leader>fe`: explorer
- `<leader>fE`: reveal current file in explorer
- `<leader>e` / `<C-n>`: explorer

## Clipboard / Edit

- `<leader>y` (n/v): yank to system clipboard
- `<leader>Y` (n): yank line to system clipboard
- `<leader>p` (v): paste without overwriting the default register
- `<C-c>` (n): copy current line to clipboard
- `<C-c>` (v): copy selection to clipboard
- `<Esc>`: clear search highlight

## Lists / Diagnostics

- `[d` / `]d`: previous / next diagnostic
- `<leader>ge` / `<leader>gE`: next / previous diagnostic
- `[q` / `]q`: previous / next quickfix item
- `<leader>xo` / `<leader>xq`: open / close quickfix list
- `<leader>xn` / `<leader>xp`: next / previous quickfix item
- `<leader>xl` / `<leader>xL`: open / close location list
- `<leader>xd` or `<leader>xx`: send diagnostics to location list

## Window / Buffer

- `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>`: switch windows
- `<leader>ws`: split below
- `<leader>wv`: split right
- `<leader>wd`: close window
- `<leader>wo`: keep only current window
- `<leader>w=`: balance windows
- `<leader>wH` / `<leader>wL`: move current window far left / right
- `gt` / `gT`: next / previous buffer
- `[b` / `]b`: previous / next buffer
- `<leader>bn` / `<leader>bp`: next / previous buffer
- `<leader>bd`: delete buffer without wrecking layout

## Code / LSP

- `gd`: definition
- `gD`: declaration
- `gr`: references
- `gI`: implementation
- `gy`: type definition
- `K`: hover docs
- `<C-k>` (insert mode): signature help
- `<leader>ca`: code action
- `<leader>cr`: rename
- `<leader>cd`: definition
- `<leader>cD`: declaration
- `<leader>ci`: implementation
- `<leader>ct`: type definition
- `<leader>cs`: document symbols
- `<leader>cS`: workspace symbols
- `<leader>cR`: rename current file with LSP support
- `<leader>cf`: format buffer
- `<leader>lf`: format buffer (compat alias)

Auto-enabled server configs:

- `lua_ls`
- `nixd`
- `basedpyright` or `pyright`
- `ts_ls`
- `clangd`
- `gopls`
- `rust_analyzer`
- `bashls`
- `jsonls`
- `yamlls`
- `marksman`

## Completion (Blink)

- Type keyword characters: auto popup suggestions
- `<C-Space>`: manually trigger completion popup
- `<Tab>`: snippet forward or select next item
- `<S-Tab>`: snippet backward or select previous item
- `<CR>`: accept current completion item
- Signature help is enabled
- Insert mode: `() [] {} '' ""` auto-pair

## Git

- `<leader>gg`: git status picker
- `<leader>gb`: git blame line (Snacks)
- `<leader>gB`: open current file / selection in remote forge
- `[h` / `]h`: previous / next hunk
- `<leader>ghs`: stage hunk
- `<leader>ghr`: reset hunk
- `<leader>ghp`: preview hunk
- `<leader>ghb`: blame line (gitsigns)
- `<leader>ghd`: diff current file
- `<leader>ghq`: send hunks to quickfix
- `<leader>ght`: toggle inline blame

## Toggles / UI

- `<leader>uw`: toggle wrap
- `<leader>us`: toggle spell
- `<leader>ul`: toggle line numbers
- `<leader>uL`: toggle relative numbers
- `<leader>ud`: toggle diagnostics
- `<leader>uh`: toggle inlay hints
- `<leader>uT`: toggle Treesitter highlighting
- `<leader>ug`: toggle indent guides
- `<leader>uD`: toggle scope dimming
- `:`: top popup command line (Noice)
- `<leader>fn`: notification history
- `<leader>un`: dismiss notifications
- `<leader>z`: zen mode
- `<leader>.`: scratch buffer
- `<leader>S`: scratch buffer picker
- `<leader>N`: open Neovim news in a floating window

## Terminal / AI

- `<Esc><Esc>` (terminal mode): back to normal mode
- `<leader>tt`: terminal (Snacks)
- `[[` / `]]`: previous / next reference from `snacks.words`
- `<leader>ac` / `<leader>aa`: open or focus existing Codex session
- `<leader>ar`: return to existing Codex session
- `<leader>an`: force new Codex session
- `<leader>aR`: open Codex resume picker (if no live session)
- `<leader>ah`: hide AI terminal windows

## Quick Jump (Flash)

- `<leader>jj`: jump
- `<leader>jt`: treesitter jump
- `<leader>jr`: remote jump
- `<leader>js`: treesitter search jump

## Plugins / Packages

- `<leader>pp`: inspect plugin state
- `<leader>pd`: prune inactive plugins from disk
- `<leader>pu`: review plugin updates
- `<leader>ps`: sync plugins to `nvim-pack-lock.json`
- `:PackPrune`: remove inactive `vim.pack` plugins from disk
- `:PackStatus`: inspect `vim.pack` plugin state
- `:PackUpdate`: review plugin updates
- `:PackSync`: sync plugins to the lockfile

## Help

- `<leader>?`: open this cheatsheet
- `:Cheatsheet`: open this cheatsheet
