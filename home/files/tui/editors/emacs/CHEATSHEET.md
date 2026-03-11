# Emacs Keybinding Cheatsheet

快速入口：
- `C-c ?` 打开这份文档（只读）
- `C-h k` 然后按一个键，查看它绑定到什么命令

## 1. 全局高频

- `C-c b`: `consult-buffer`
- `C-c f`: `consult-find`
- `C-c s`: `consult-ripgrep`
- `C-c /`: `consult-line`
- `M-o`: `ace-window`
- `C-c v`: `vterm-other-window`
- `C-c g`: `magit-status`
- `C-c h`: `helpful-at-point`
- `C-,`: 复制当前行

## 2. LSP / 诊断 / 文档

- `C-c d`: `xref-find-definitions`
- `C-c u`: `xref-find-references`
- `C-c r`: `eglot-rename`
- `C-c a`: `eglot-code-actions`
- `C-c n`: `flymake-goto-next-error`
- `C-c j`: `flymake-goto-prev-error`
- `C-c e`: `eldoc-box-help-at-point`

`C-c l` 前缀：
- `C-c l s`: `eglot`
- `C-c l c`: `eglot-reconnect`
- `C-c l q`: `eglot-shutdown`
- `C-c l o`: `eglot-code-action-organize-imports`
- `C-c l f`: `eglot-format-buffer`
- `C-c l i`: `eglot-find-implementation`
- `C-c l t`: `xref-find-type-definitions`
- `C-c l b`: `eldoc-doc-buffer`
- `C-c l e`: `eglot-events-buffer`

## 3. Snippets

`C-c y` 前缀：
- `C-c y e`: `yas-expand`
- `C-c y i`: `yas-insert-snippet`
- `C-c y n`: `yas-new-snippet`
- `C-c y v`: `yas-visit-snippet-file`
- `C-c y r`: `yas-reload-all`

## 4. Treemacs / Workspace

- `C-c t`: `treemacs`（toggle）
- `C-c w`: 选目录；若已存在所属 workspace 则切换，否则新建同名 workspace 并加入该目录
- `C-c C-w`: `treemacs-switch-workspace`
- `C-c o`: `treemacs-select-window`
- `C-c p`: `treemacs-add-project-to-workspace`

## 5. Completion / Minibuffer 细节

Corfu（补全弹窗）：
- `TAB`: `corfu-insert`（确认候选）
- `RET`: 保持回车本义（换行）
- `M-SPC`: `corfu-insert-separator`
- `M-d`: `corfu-popupinfo-documentation`
- `M-l`: `corfu-popupinfo-location`

Vertico（minibuffer）：
- `C-j`: 下一个候选
- `C-k`: 上一个候选
- `M-p`: `vertico-repeat-previous`
- `M-n`: `vertico-repeat-next`
- `RET`: `vertico-directory-enter`（文件补全时进入目录）
- `DEL`: `vertico-directory-delete-char`
- `M-DEL`: `vertico-directory-delete-word`
- `M-A`: `marginalia-cycle`

Embark：
- `C-.`: `embark-act`
- `C-;`: `embark-dwim`
- `C-h B`: `embark-bindings`

## 6. `C-c c` 扩展前缀

- `C-c c g`: `consult-goto-line`
- `C-c c o`: `consult-outline`
- `C-c c e`: `consult-compile-error`
- `C-c c n`: `consult-flymake`
- `C-c c h`: `consult-history`
- `C-c c m`: `consult-mode-command`
- `C-c c k`: `consult-kmacro`
- `C-c c y`: `consult-yank-pop`
- `C-c c x`: `consult-bookmark`
- `C-c c v`: `vertico-repeat`
- `C-c c d`: `magit-dispatch`
- `C-c c f`: `magit-file-dispatch`

## 7. 编辑增强

- `M-<up>`: `move-text-up`
- `M-<down>`: `move-text-down`
- `C-S-c C-S-c`: `mc/edit-lines`
- `C->`: `mc/mark-next-like-this`
- `C-<`: `mc/mark-previous-like-this`
- `C-c C-<`: `mc/mark-all-dwim`
- `C-c C->`: `mc/mark-all-dwim`

## 8. Markdown（内置工作流）

在 `markdown-mode` / `gfm-mode`：
- `C-c C-c p`: 预览 HTML
- `C-c C-c l`: 切换 live preview（Emacs 内）

## 9. AI（Codex CLI）

- `C-c C-a`: `ai-code-menu`
- `C-c C-z`: `rc/ai-resume`
- `C-c z`: `rc/ai-switch`
- `C-c q`: `rc/ai-hide`
