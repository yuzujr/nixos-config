# Neovim Cheatsheet

Leader key: `<Space>`

## Clipboard / Edit

- `<leader>y` (n/v): yank to system clipboard
- `<leader>Y` (n): yank line to system clipboard
- `<C-c>` (n): copy current line to clipboard
- `<C-c>` (v): copy selection to clipboard
- `<C-,>`: duplicate current line

## Core Navigation / Quickfix

- `[d` / `]d`: previous / next diagnostic
- `[q` / `]q`: previous / next quickfix item
- `<leader>xq`: close quickfix list
- `<leader>xo`: open quickfix list

## Window / Buffer

- `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>`: switch to left/down/up/right window
- `<leader>wH` / `<leader>wL`: move current window far left/right
- `gt` / `gT`: next / previous buffer

## Find / Explorer (Snacks)

- `<leader><space>`: smart find
- `<leader>ff`: files
- `<leader>fr`: recent files
- `<leader>fg`: grep
- `<leader>fb`: buffers
- `<leader>fh`: help tags
- `<leader>fk`: keymaps
- `<leader>fd`: diagnostics picker
- `<leader>f/`: resume previous picker
- `<leader>fe`: explorer
- `<leader>fE`: reveal current file in explorer
- `<leader>e` / `<C-n>`: explorer

## Code / LSP

- `gd`: definition
- `gr`: references
- `gi`: implementation
- `K`: hover docs
- `<leader>ca`: code action
- `<leader>cr`: rename
- `<leader>cd`: definition
- `<leader>cD`: declaration
- `<leader>ci`: implementation
- `<leader>cs`: workspace symbols
- `<leader>cf`: format buffer
- `<leader>lf`: format buffer (compat alias)
- `<leader>xd` (`<leader>xx` alias): diagnostics -> location list

## Completion (Blink)

- Type keyword characters: auto popup suggestions
- `<C-Space>`: manually trigger completion popup
- `<Tab>`: accept/select completion (super-tab preset)
- `<S-Tab>`: snippet backward / fallback
- `<C-e>`: close completion menu
- Insert mode: `() [] {} '' ""` auto-pair

## Git

- `<leader>gg`: git status picker
- `<leader>gb`: git blame line (Snacks)
- `[h` / `]h`: previous / next hunk
- `<leader>ghs`: stage hunk
- `<leader>ghr`: reset hunk
- `<leader>ghp`: preview hunk
- `<leader>ghb`: blame line (gitsigns)

## UI

- `<leader>w`: wrap lines on
- `<leader>W`: wrap lines off
- `:`: top popup command line (Noice)

## Terminal / AI

- `<Esc><Esc>` (terminal mode): back to normal mode
- `<leader>tt`: terminal (Snacks)
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

## Help

- `<leader>?`: open this cheatsheet
