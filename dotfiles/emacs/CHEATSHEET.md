# Emacs Keybinding Cheatsheet

快速入口：
- `C-c ?` 打开这份文档（只读）
- `C-h k` 然后按一个键，查看它绑定到什么命令
- 停顿片刻看 `which-key`，可看到当前前缀下还能按什么

## 高频

- `C-x b`: `consult-buffer`
- `C-c f`: `project-find-file`
- `C-c s`: `consult-ripgrep`
- `C-c /`: `consult-line`
- `M-g g`: `consult-goto-line`
- `C-c j`: `avy-goto-char-timer`
- `C-c p`: `project-switch-project`
- `C-c t`: `project-dired`
- `C-c w`: `project-find-dir`
- `C-c o`: `dired-jump`
- `C-c e`: `eat`
- `C-c c`: `compile`
- `M-o`: `ace-window`
- `C-c g`: `magit-status`
- `C-c h`: `helpful-at-point`
- `C-,`: 复制当前行

## Dired

- `n` / `p`: 上下移动
- `TAB`: 打开当前文件 / 进入当前目录
- `S-TAB`: 返回上级目录
- `^`: 返回上级目录

## 代码导航 / LSP

- `C-c j`: 输入目标位置的字符后按提示跳转（类似 `flash.nvim`）
- `C-c J`: `avy-goto-line`
- `C-c C-j`: `avy-resume`
- `C-c d`: `xref-find-definitions`
- `C-c u`: `xref-find-references`
- `C-c i`: `consult-imenu`
- `C-c r`: `eglot-rename`
- `C-c a`: `eglot-code-actions`
- `M-n`: 下一条诊断
- `M-p`: 上一条诊断
- `C-c n`: `consult-flymake`
- 当前行 Flymake 诊断会显示在右侧 sideline

`C-c l` 常用：
- `C-c l f`: `eglot-format-buffer`

## 补全 / Minibuffer

- `M-y`: `consult-yank-pop`

Corfu（补全弹窗）：
- `TAB`: 确认候选
- `M-d`: 显示文档
- `M-l`: 显示候选位置

Vertico（minibuffer）：
- `RET`: 进入目录 / 确认当前项
- `DEL`: 删除字符；在 `/` 处退回上级目录
- `M-DEL`: 删除一个词；在 `/` 处退回上级目录
- `M-A`: `marginalia-cycle`

## 编辑

- `M-<up>`: 上移当前行/选区
- `M-<down>`: 下移当前行/选区
- `C-=`: 扩大选区
- `C->`: `mc/mark-next-like-this`
- `C-<`: `mc/mark-previous-like-this`
- `C-c m l`: `mc/edit-lines`
- `C-c m a`: `mc/mark-all-dwim`
