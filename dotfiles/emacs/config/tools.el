;;; tools.el -*- lexical-binding: t; -*-

(provide 'tools)

(defvar rc/state-directory)

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
;; Terminal - Eat
;; ----------------------------
(use-package eat
  :commands (eat)
  :bind (("C-c c t" . eat))
  :config
  (dolist (map '(eat-semi-char-mode-map
                 eat-char-mode-map
                 eat-eshell-semi-char-mode-map
                 eat-eshell-char-mode-map))
    (keymap-set (symbol-value map) "M-o" #'ace-window)))

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

(defun rc/project-try-rust-subcrate (dir)
  "Treat nested Rust crates as projects when the VC root is not a Cargo workspace.

This keeps a Git repository without a top-level `Cargo.toml' from
being used as the Rust project root, while leaving real Cargo
workspaces alone."
  (let ((manifest-dir (locate-dominating-file dir "Cargo.toml")))
    (when manifest-dir
      (let* ((project-vc-extra-root-markers nil)
             ;; Bypass `project-try-vc' cache so the result can depend on
             ;; whether we are considering `Cargo.toml' as a root marker.
             (vc-project (project-try-vc--search dir))
             (vc-root (and vc-project (project-root vc-project))))
        (when (and vc-root
                   (not (file-exists-p (expand-file-name "Cargo.toml" vc-root)))
                   (not (file-equal-p manifest-dir vc-root)))
          (let ((project-vc-extra-root-markers '("Cargo.toml")))
            (project-try-vc--search dir)))))))

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".project"))
  :config
  (add-hook 'project-find-functions #'rc/project-try-rust-subcrate))

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
