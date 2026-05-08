;;; tools.el -*- lexical-binding: t; -*-

(provide 'tools)

(defvar rc/state-directory)

;; ----------------------------
;; Git - Magit
;; ----------------------------
(use-package magit
  :bind (("C-c g" . magit-status)))

(defun rc/diff-hl-dired-mode ()
  "Enable `diff-hl-dired-mode' after loading its integration module."
  (require 'diff-hl-dired)
  (diff-hl-dired-mode 1))

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (text-mode . diff-hl-mode)
         (dired-mode . rc/diff-hl-dired-mode))
  :config
  (with-eval-after-load 'magit
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

;; ----------------------------
;; Terminal - Eat
;; ----------------------------
(use-package eat
  :commands (eat)
  :bind (("C-c e" . eat))
  :config
  (dolist (map '(eat-semi-char-mode-map
                 eat-char-mode-map
                 eat-eshell-semi-char-mode-map
                 eat-eshell-char-mode-map))
    (keymap-set (symbol-value map) "M-o" #'ace-window)))

;; ----------------------------
;; Build - Compile
;; ----------------------------
(use-package compile
  :ensure nil
  :custom
  (compilation-auto-jump-to-first-error 'first-known)
  (compilation-scroll-output 'first-error))

;; ----------------------------
;; Navigation - Project + Dired
;; ----------------------------
(use-package projectile
  :demand t
  :bind-keymap ("C-c p" . projectile-command-map)
  :bind (("C-c f" . projectile-find-file)
         ("C-c o" . projectile-switch-project)
         ("C-c w" . projectile-dired)
         ("C-c c" . projectile-compile-project)
         ("C-c R" . projectile-run-project))
  :custom
  (projectile-cache-file (expand-file-name "projectile.cache" rc/state-directory))
  (projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" rc/state-directory))
  (projectile-completion-system 'default)
  (projectile-enable-caching t)
  (projectile-indexing-method 'alien)
  (projectile-switch-project-action #'projectile-dired)
  :config
  (projectile-mode 1))

;; Flash-like in-buffer jump labels.
(use-package avy
  :bind (("C-c j" . avy-goto-char-timer)
         ("C-c J" . avy-goto-line)
         ("C-c C-j" . avy-resume))
  :custom
  (avy-timeout-seconds 0.3)
  (avy-background t)
  (avy-all-windows t)
  (avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("TAB" . dired-find-file)
              ("<backtab>" . dired-up-directory))
  :custom
  (dired-kill-when-opening-new-dired-buffer t))

(use-package dired-x
  :ensure nil)

;; ----------------------------
;; Editing Enhancements
;; ----------------------------
;; Move lines/regions up and down
(use-package move-text
  :bind (("M-<up>" . move-text-up)
         ("M-<down>" . move-text-down)))

;; Expand the active region by semantic units.
(use-package expand-region
  :bind (("C-=" . er/expand-region)))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C->"       . mc/mark-next-like-this)
         ("C-<"       . mc/mark-previous-like-this)
         ("C-c m l"   . mc/edit-lines)
         ("C-c m a"   . mc/mark-all-dwim)
         ("C-c m n"   . mc/mark-next-like-this)
         ("C-c m p"   . mc/mark-previous-like-this))
  :custom
  (mc/always-run-for-all t))

;; Window management
(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; ----------------------------
;; Help System Enhancement
;; ----------------------------
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c h" . helpful-at-point)))

;; ----------------------------
;; Which-key - Display Keybindings
;; ----------------------------
(use-package which-key
  :demand t
  :custom
  (which-key-idle-delay 0.5)
  (which-key-sort-order 'which-key-key-order-alpha)
  :config
  (which-key-mode)
  (which-key-add-key-based-replacements
    "C-c /" "line-search"
    "C-c c" "project-compile"
    "C-c e" "terminal"
    "C-c f" "project-file"
    "C-c i" "imenu"
    "C-c l" "lsp"
    "C-c m" "multi-cursor"
    "C-c j" "avy-jump"
    "C-c J" "avy-line"
    "C-c n" "diagnostics"
    "C-c o" "project-switch"
    "C-c p" "projectile"
    "C-c s" "consult-ripgrep"
    "C-c w" "project-dired"
    "C-c b" "consult-project-buffer"
    "C-c R" "project-run"
    "C-c ?" "cheatsheet"))

;; ----------------------------
;; direnv - Manage Environment
;; ----------------------------
(use-package direnv
  :custom
  (direnv-always-show-summary nil)
  :config
  (direnv-mode))

;;; tools.el ends here
