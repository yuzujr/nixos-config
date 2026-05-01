;;; tools.el -*- lexical-binding: t; -*-

(provide 'tools)

;; ----------------------------
;; Git - Magit
;; ----------------------------
(use-package magit
  :bind (("C-c g" . magit-status)
         ("C-c c d" . magit-dispatch)
         ("C-c c f" . magit-file-dispatch)))

;; ----------------------------
;; Sudo Edit - Edit as Root
;; ----------------------------
(use-package sudo-edit
  :commands (sudo-edit sudo-edit-find-file))

;; ----------------------------
;; Navigation - Project + Dired
;; ----------------------------
(keymap-global-set "C-c f" #'project-find-file)
(keymap-global-set "C-c p" #'project-switch-project)
(keymap-global-set "C-c t" #'project-dired)
(keymap-global-set "C-c w" #'project-find-dir)
(keymap-global-set "C-c o" #'dired-jump)

(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("TAB" . dired-find-file)
              ("<backtab>" . dired-up-directory))
  :custom
  (dired-kill-when-opening-new-dired-buffer t))

(use-package dired-x
  :ensure nil)

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".project")))

;; ----------------------------
;; Editing Enhancements
;; ----------------------------
;; Move lines/regions up and down
(use-package move-text
  :bind (("M-<up>" . move-text-up)
         ("M-<down>" . move-text-down)))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-dwim)
         ("C-c C->"     . mc/mark-all-dwim))
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
    "C-c b" "buffers"
    "C-c c" "extra"
    "C-c f" "project-file"
    "C-c F" "fd"
    "C-c l" "lsp-extra"
    "C-c o" "dired-jump"
    "C-c p" "project-switch"
    "C-c s" "ripgrep"
    "C-c t" "project-dired"
    "C-c w" "project-dir"
    "C-c y" "snippets"
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
