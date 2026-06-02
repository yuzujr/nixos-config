# Emacs Cheatsheet

配置入口：`init.el` 依次加载 `editor`、`org-config`、`ui`、`completion`、`lsp`、`programming`、`tools`、`functions`。  
原则：先用下面的工作流；想看某个前缀下的完整命令，按前缀后停一下看 `which-key`。

## 0. 必记入口

| 键位 | 命令 | 用途 |
| --- | --- | --- |
| `C-c ?` | `rc/open-cheatsheet` | 打开本文件，只读查看 |
| `C-h k` | `helpful-key` | 查一个键实际绑定到什么 |
| `C-h f` | `helpful-callable` | 查函数/命令 |
| `C-h v` | `helpful-variable` | 查变量 |
| `C-h x` | `helpful-command` | 查命令 |
| `C-c h` | `helpful-at-point` | 查光标处符号 |
| `M-x` | `execute-extended-command` | 运行没有绑定键的命令 |

## 1. 日常工作流

### 打开项目

1. `C-c o` 切换项目，默认进入该项目的 Dired。
2. `C-c f` 用 `projectile-find-file` 查找项目文件。
3. `C-c b` 切换当前项目 buffer/文件；`C-x b` 切全局 buffer。
4. `C-c p` 打开 Projectile 全功能菜单，停一下看 `which-key`。

相关插件：`consult`、`projectile`、`vertico`、`orderless`、`marginalia`、`prescient`、`savehist`。

### 查找内容

1. `C-c s` 在项目内 ripgrep，当前绑定为 `consult-ripgrep`。
2. `C-c /` 在当前 buffer 内搜索行。
3. `C-c i` 跳到当前文件的 imenu 符号。
4. Consult 搜索根目录由 `rc/consult-project-root` 决定：只使用 Projectile 项目根；取不到则由 Consult 退回当前目录。

相关插件：`projectile`、`consult`、`consult-imenu`。

### 跳转代码

1. `C-c d` 跳定义。
2. `C-c u` 查引用。
3. `C-c l i` 跳实现。
4. `C-c l t` 跳类型定义。
5. `C-c j` 输入字符后用 Avy 快速跳到屏幕位置。
6. `C-c J` 跳行，`C-c C-j` 恢复上次 Avy。

相关插件：`eglot`、`xref`、`consult-xref`、`avy`。

### 写代码

1. Corfu 弹出补全后按 `TAB` 接受候选，`RET` 不接受候选。
2. `C-c a` 执行 code action。
3. `C-c r` 重命名符号。
4. `C-c l f` 格式化当前 buffer。
5. `M-n` / `M-p` 跳下一条/上一条诊断。
6. `C-c n` 打开诊断列表。

相关插件：`corfu`、`corfu-popupinfo`、`yasnippet`、`eglot`、`flymake`、`sideline`、`sideline-flymake`。

### 构建、运行、终端

1. `C-c c` 编译当前项目。
2. `C-c R` 运行当前项目。
3. `M-x compile` 手动输入编译命令。
4. `C-c e` 打开 Eat 终端。
5. 在 Eat 里也可用 `M-o` 切窗口。

相关插件：`compile`、`projectile`、`eat`、`ace-window`、`direnv`。

### 提交代码

1. `C-c g` 打开 Magit。
2. 直接看 buffer 边栏的 `diff-hl` 变更提示。
3. Magit 刷新后 `diff-hl` 会同步刷新。

相关插件：`magit`、`diff-hl`。

## 2. 高频键位

| 键位 | 命令 |
| --- | --- |
| `C-x b` | `consult-buffer` |
| `C-c f` | `projectile-find-file` |
| `C-c s` | `consult-ripgrep` |
| `C-c /` | `consult-line` |
| `M-g g` | `consult-goto-line` |
| `M-y` | `consult-yank-pop` |
| `C-c o` | `projectile-switch-project` |
| `C-c w` | `projectile-dired` |
| `C-c b` | `consult-project-buffer` |
| `C-c c` | `projectile-compile-project` |
| `C-c R` | `projectile-run-project` |
| `C-c g` | `magit-status` |
| `C-c e` | `eat` |
| `M-o` | `ace-window` |
| `C-,` | `rc/duplicate-line` |

## 3. Minibuffer、补全、历史

### Vertico / Orderless / Marginalia

| 键位 | 作用 |
| --- | --- |
| `RET` | 确认候选；在目录候选上进入目录 |
| `DEL` | 删除字符；在路径分隔处退回上级目录 |
| `M-DEL` | 删除一个词；在路径分隔处退回上级目录 |
| `M-A` | 切换 Marginalia 注释样式 |
| `<` | Consult 命令里的 narrow key |

用法：
- 匹配支持 Orderless，多段关键词用空格分开。
- Vertico 候选按 Prescient 的频率和最近使用排序。
- minibuffer 历史由 Savehist 持久化，重启后仍可用。

### Corfu / Popupinfo / Yasnippet

| 键位 | 作用 |
| --- | --- |
| `TAB` | 接受 Corfu 候选 |
| `M-SPC` | 插入补全分隔符 |
| `M-d` | 显示候选文档 |
| `M-l` | 显示候选来源位置 |
| `C-c & C-s` | 插入 Yasnippet snippet |
| `C-c & C-n` | 新建 snippet |
| `C-c & C-v` | 访问 snippet 文件 |

说明：
- Corfu 全局开启，自动补全延迟 `0.08s`，前缀长度 `1`。
- Yasnippet 在 `prog-mode` 开启，snippet 目录是 `snippets/`。
- Eglot 的 snippet 风格补全依赖 Yasnippet 展开。

## 4. 项目与文件

### Consult 项目入口

| 键位 | 命令 | 用途 |
| --- | --- | --- |
| `C-c s` | `consult-ripgrep` | 从项目根搜索文本 |
| `C-c b` | `consult-project-buffer` | 切换当前项目 buffer/文件 |

这些命令通过 `rc/consult-project-root` 取项目根：只使用 Projectile。

### Projectile

| 键位 | 命令 |
| --- | --- |
| `C-c p` | `projectile-command-map` |
| `C-c f` | `projectile-find-file` |
| `C-c o` | `projectile-switch-project` |
| `C-c w` | `projectile-dired` |
| `C-c c` | `projectile-compile-project` |
| `C-c R` | `projectile-run-project` |

项目根：
- VCS 根目录和常见 manifest 会自动识别。
- `.projectile` 可手动标记项目根，并写 include/ignore 规则。
- 已知项目和缓存保存在 XDG state 目录下。

### Dired / Dired-X

| 键位 | 命令 |
| --- | --- |
| `TAB` | `dired-find-file` |
| `S-TAB` | `dired-up-directory` |
| `^` | `dired-up-directory` |
| `n` / `p` | 下一行 / 上一行 |
| `C-x C-j` | `dired-jump` |
| `C-x 4 C-j` | `dired-jump-other-window` |

说明：
- `dired-dwim-target` 开启，双窗口复制/移动时会默认猜另一个 Dired 目录。
- 打开新 Dired buffer 时旧 Dired buffer 会被清理。

## 5. LSP、诊断、代码导航

### Eglot

自动启动的模式：
- `python-ts-mode`
- `c-ts-mode`
- `c++-ts-mode`
- `rust-ts-mode`
- `rust-mode`
- `nix-ts-mode`，服务器配置为 `nixd`

保存行为：Eglot 管理的 buffer 会在 LSP server 支持 `textDocument/formatting` 时，保存前运行 `eglot-format-buffer`。

| 键位 | 命令 |
| --- | --- |
| `C-c l s` | `eglot` |
| `C-c l c` | `eglot-reconnect` |
| `C-c l q` | `eglot-shutdown` |
| `C-c l o` | `eglot-code-action-organize-imports` |
| `C-c l f` | `eglot-format-buffer` |
| `C-c l i` | `eglot-find-implementation` |
| `C-c l t` | `xref-find-type-definitions` |
| `C-c l b` | `eldoc-doc-buffer` |
| `C-c a` | `eglot-code-actions` |
| `C-c r` | `eglot-rename` |

### Xref / Flymake / Sideline

| 键位 | 命令 |
| --- | --- |
| `C-c d` | `xref-find-definitions` |
| `C-c u` | `xref-find-references` |
| `C-c i` | `consult-imenu` |
| `C-c n` | `consult-flymake` |
| `M-n` | `flymake-goto-next-error` |
| `M-p` | `flymake-goto-prev-error` |

说明：
- Xref 结果使用 `consult-xref` 展示。
- Flymake 诊断会通过 Sideline 显示在当前行右侧。
- Sideline 的 Flymake 文本经过配置裁剪，避免过长诊断挤爆窗口。

## 6. 编辑增强

| 键位 | 命令 | 用途 |
| --- | --- | --- |
| `C-,` | `rc/duplicate-line` | 复制当前行 |
| `M-<up>` | `move-text-up` | 上移行/选区 |
| `M-<down>` | `move-text-down` | 下移行/选区 |
| `C-=` | `er/expand-region` | 扩大选区 |
| `C->` | `mc/mark-next-like-this` | 选中下一个相同项 |
| `C-<` | `mc/mark-previous-like-this` | 选中上一个相同项 |
| `C-c m l` | `mc/edit-lines` | 多光标编辑多行 |
| `C-c m a` | `mc/mark-all-dwim` | 智能选中全部匹配 |
| `C-c m n` | `mc/mark-next-like-this` | 多光标下一个 |
| `C-c m p` | `mc/mark-previous-like-this` | 多光标上一个 |

基础行为：
- 缩进默认 4 空格，不使用 tab。
- `electric-pair-mode` 自动补括号。
- C/C++ 里禁用冒号导致的 label 式自动缩进，输入 `std::` 更稳定。
- 文件外部变化会自动 revert。
- 访问过的文件会自动保存，同时保留 Emacs recovery auto-save。

## 7. 界面与窗口

| 功能 | 实际配置 |
| --- | --- |
| 字体 | `Maple Mono NF CN`，高度 `130`，regular |
| 透明度 | `rc/frame-opacity = 100` |
| 主题 | `doom-rose-pine` / `doom-rose-pine-dawn` |
| 明暗切换 | 启动时读取一次 XDG Desktop Portal color-scheme |
| 居中编辑 | `olivetti-mode` 在 `prog-mode` 开启，宽度 `120` |
| 行号 | `global-display-line-numbers-mode` 开启 |
| 分屏 | 单窗口优先右分；多窗口优先在最右列向下堆叠 |
| 滚动 | `scroll-margin = 5`，偏向平滑和低延迟 |

窗口操作：
- `M-o` 使用 Ace Window 按字母选窗口。
- Ace Window 字母为 `a s d f g h j k l`。

## 8. Git、终端、环境

| 插件/功能 | 入口 | 说明 |
| --- | --- | --- |
| Magit | `C-c g` | Git porcelain |
| Diff-hl | 自动 | `prog-mode`、`text-mode`、`dired-mode` 显示变更 |
| Eat | `C-c e` | Emacs 内终端 |
| Compile | `C-c c` / `M-x compile` | 编译输出自动跳第一条已知错误 |
| Direnv | 自动 | 进入项目时加载 `.envrc` 环境 |

Direnv 提醒：
- 首次进入含 `.envrc` 的目录，通常需要在 shell 里执行 `direnv allow`。
- Emacs 内部会静默应用环境，配置关闭了常驻 summary。

## 9. 语言与文档

### Tree-sitter

- `treesit-auto` 全局开启，并把支持的文件类型映射到 tree-sitter mode。
- grammar 安装策略是 `prompt`，缺 grammar 时会询问。
- `treesit-install-language-grammar` 安装位置被重定向到 XDG cache 下的 `tree-sitter/`。

### 语言模式

| 文件/语言 | Mode | 额外说明 |
| --- | --- | --- |
| Rust | `rust-mode` / `rust-ts-mode` | `rust-mode-treesitter-derive` 开启 |
| Nix | `nix-ts-mode` | Eglot 使用 `nixd` |
| GLSL | `glsl-ts-mode` | 匹配 `.glsl`、`.vert`、`.frag` |
| KDL | `kdl-mode` | 匹配 `.kdl` |
| Markdown | `gfm-mode` | `.md`、`.markdown`、`README.md` |
| Org | `org-mode` | Babel 启用 shell、python、C、C++ |

Markdown：
- `markdown-command` 是 `cmark-gfm -e table -e strikethrough -e autolink -e tagfilter -e tasklist -e footnotes`。
- `C-c C-c l` / `M-x markdown-live-preview-mode` 使用 EWW 预览。
- 预览 HTML 写到临时目录，不污染源码目录。
- `cmark-gfm` 默认按 CommonMark 解析，不自动启用 GFM 扩展；表格需要 `-e table`，否则会按普通段落输出。

Markdown 常用键位：

| 键位 | 命令 | 用途 |
| --- | --- | --- |
| `C-c C-c l` | `markdown-live-preview-mode` | 开关 EWW live preview |
| `C-c C-c p` | `markdown-preview` | 生成并预览 HTML |
| `C-c C-c e` | `markdown-export` | 导出 HTML |
| `C-c C-c o` | `markdown-open` | 打开已导出的 HTML |
| `C-c C-s b` | `markdown-insert-bold` | 粗体 |
| `C-c C-s i` | `markdown-insert-italic` | 斜体 |
| `C-c C-s c` | `markdown-insert-code` | 行内代码 |
| `C-c C-s C` | `markdown-insert-gfm-code-block` | GFM 代码块 |
| `C-c C-s q` | `markdown-insert-blockquote` | 引用块 |
| `C-c C-t h` | `markdown-insert-header-dwim` | 自动插入标题 |
| `C-c C-t 1..6` | `markdown-insert-header-atx-1..6` | 插入 1-6 级 ATX 标题 |
| `C-c C-l` | `markdown-insert-link` | 插入链接 |
| `C-c TAB` | `markdown-insert-image` | 插入图片 |
| `M-RET` | `markdown-insert-list-item` | 插入列表项 |
| `TAB` / `S-TAB` | `markdown-cycle` / `markdown-shifttab` | 折叠当前/全局标题 |
| `C-c <left>` / `C-c <right>` | `markdown-promote` / `markdown-demote` | 提升/降低标题、列表或表格列 |
| `C-c <up>` / `C-c <down>` | `markdown-move-up` / `markdown-move-down` | 上下移动标题、列表或表格行 |

Org Babel：
- 在代码块上 `C-c C-c` 执行。
- Python 命令是 `python3`，默认结果为 `output`。
- C 编译器是 `gcc`，C++ 编译器是 `g++`。
- `org-confirm-babel-evaluate` 为 `nil`，执行代码块不会二次确认。

## 10. 状态文件与自动保存

XDG 目录：
- Cache：`$XDG_CACHE_HOME/emacs/` 或 `~/.cache/emacs/`
- Data：`$XDG_DATA_HOME/emacs/` 或 `~/.local/share/emacs/`
- State：`$XDG_STATE_HOME/emacs/` 或 `~/.local/state/emacs/`

放在 state/cache 的内容：
- backup 文件
- auto-save 文件
- auto-save session list
- Projectile 缓存和已知项目
- Transient 历史、levels、values
- Savehist 历史
- Prescient 排序历史
- Tree-sitter grammar
- native-comp eln cache

## 11. 插件总表

这张表覆盖当前配置里的所有 `use-package` 声明，避免装了但忘记入口。

| 插件 | 使用入口 / 生效方式 |
| --- | --- |
| `vertico` | minibuffer 垂直候选，自动开启 |
| `vertico-directory` | `RET`、`DEL`、`M-DEL` 增强路径输入 |
| `corfu` | buffer 内补全，`TAB` 接受 |
| `corfu-popupinfo` | `M-d` 文档，`M-l` 位置 |
| `savehist` | 持久化 minibuffer 历史，自动 |
| `prescient` | 候选频率/最近使用排序，自动 |
| `vertico-prescient` | Vertico 候选排序，自动 |
| `corfu-prescient` | Corfu 候选排序，自动 |
| `orderless` | 空格分段模糊匹配，自动 |
| `marginalia` | minibuffer 注释，`M-A` 切换 |
| `consult` | `C-x b`、`C-c s`、`C-c /`、`C-c b`、`M-g g`、`M-y` |
| `consult-flymake` | `C-c n` |
| `consult-imenu` | `C-c i` |
| `consult-xref` | Xref 结果自动改用 Consult |
| `doom-themes` | 用于加载doom-rose-pine |
| `olivetti` | `prog-mode` 自动居中，宽度 `120` |
| `yasnippet` | `prog-mode` 自动开启，`C-c & C-s/n/v` |
| `xref` | `C-c d`、`C-c u` |
| `flymake` | Eglot/语言后端诊断，`M-n`、`M-p` |
| `sideline` | Flymake 诊断右侧行内显示 |
| `sideline-flymake` | Sideline 的 Flymake 后端 |
| `eglot` | LSP，`C-c l ...`、`C-c a`、`C-c r` |
| `org` | Org 与 Babel，shell/python/C/C++ |
| `treesit-auto` | 自动启用 tree-sitter modes |
| `rust-mode` | Rust mode，tree-sitter derive |
| `nix-ts-mode` | `.nix`，Eglot 服务器 `nixd` |
| `glsl-ts-mode` | `.glsl`、`.vert`、`.frag` |
| `kdl-mode` | `.kdl` |
| `markdown-mode` | GFM Markdown，EWW live preview |
| `magit` | `C-c g` |
| `diff-hl` | 自动显示 Git diff，含 Dired/Magit 集成 |
| `eat` | `C-c e` |
| `compile` | `M-x compile`，Projectile 编译绑定 `C-c c` |
| `projectile` | 提供项目根识别；`C-c p` 菜单，`C-c f/o/w/c/R` |
| `avy` | `C-c j`、`C-c J`、`C-c C-j` |
| `dired` | `TAB` 打开，`S-TAB` / `^` 上级 |
| `dired-x` | `C-x C-j`、`C-x 4 C-j` |
| `move-text` | `M-<up>`、`M-<down>` |
| `expand-region` | `C-=` |
| `multiple-cursors` | `C->`、`C-<`、`C-c m ...` |
| `ace-window` | `M-o` |
| `helpful` | `C-h f/v/k/x`、`C-c h` |
| `which-key` | 按前缀后停顿显示可用键 |
| `direnv` | 自动加载项目环境 |

## 12. 备注

- `diff-hl`、`direnv`、`olivetti`、`sideline`、`savehist`、`prescient` 都主要是自动生效插件，平时不需要手动调用。
- 本配置 `use-package-always-ensure` 为 `nil`，不会自动安装包；包来源应由系统/Nix 提供。
