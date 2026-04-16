# Emacs Keybinding Cheatsheet

快速入口：
- `C-c ?` 打开这份文档（只读）
- `C-h k` 然后按一个键，查看它绑定到什么命令
- 停顿片刻看 `which-key`，可看到当前前缀下还能按什么

## 高频

- `C-c b`: `consult-buffer`
- `C-c f`: `project-find-file`
- `C-c s`: `consult-ripgrep`
- `C-c /`: `consult-line`
- `C-c p`: `project-switch-project`
- `C-c t`: `project-dired`
- `C-c w`: `project-find-dir`
- `C-c o`: `dired-jump`
- `M-o`: `ace-window`
- `C-c g`: `magit-status`
- `C-c h`: `helpful-at-point`
- `C-,`: 复制当前行

## 代码导航 / LSP

- `C-c d`: `xref-find-definitions`
- `C-c u`: `xref-find-references`
- `C-c r`: `eglot-rename`
- `C-c a`: `eglot-code-actions`
- `C-c j`: 下一条诊断
- `C-c k`: 上一条诊断
- `C-c e`: `eldoc-box-help-at-point`

`C-c l` 常用：
- `C-c l f`: `eglot-format-buffer`
- `C-c l o`: `eglot-code-action-organize-imports`
- `C-c l i`: `eglot-find-implementation`
- `C-c l t`: `xref-find-type-definitions`
- 其他 LSP 子命令直接看 `which-key`

## 补全 / Minibuffer

- `C-.`: `embark-act`
- `C-;`: `embark-dwim`
- `C-h B`: `embark-bindings`

Corfu（补全弹窗）：
- `TAB`: 确认候选
- `M-d`: 显示文档
- `M-l`: 显示候选位置

Vertico（minibuffer）：
- `RET`: 进入目录 / 确认当前项
- `DEL`: 删除字符；在 `/` 处退回上级目录
- `M-DEL`: 删除一个词；在 `/` 处退回上级目录
- `M-g`: `consult-dir`
- `M-A`: `marginalia-cycle`
- `C-c c v`: `vertico-repeat`

`C-c c` 常用：
- `C-c c g`: `consult-goto-line`
- `C-c c o`: `consult-outline`
- `C-c c n`: `consult-flymake`
- `C-c c y`: `consult-yank-pop`
- `C-c c x`: `consult-bookmark`
- `C-c c d`: `magit-dispatch`
- `C-c c f`: `magit-file-dispatch`

## 编辑

- `M-<up>`: 上移当前行/选区
- `M-<down>`: 下移当前行/选区
- `C-S-c C-S-c`: `mc/edit-lines`
- `C->`: `mc/mark-next-like-this`
- `C-<`: `mc/mark-previous-like-this`
- `C-c C-<`: `mc/mark-all-dwim`

## Snippets

- `C-c y e`: `yas-expand`
- `C-c y i`: `yas-insert-snippet`
