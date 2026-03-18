;;; editor.el -*- lexical-binding: t; -*-

(provide 'editor)

(defvar rc/state-directory)

;; ----------------------------
;; Basic Editor Settings
;; ----------------------------
(setq-default tab-width 4
              indent-tabs-mode nil
              c-basic-offset 4
              c-ts-mode-indent-offset 4)

;; Compilation
(setq byte-compile-verbose nil
      byte-compile-warnings nil)

;; ----------------------------
;; Editing Behavior
;; ----------------------------
;; Auto-pairing brackets
(electric-pair-mode 1)

;; C-mode settings
(add-hook 'c-mode-common-hook
          (lambda ()
            (c-toggle-electric-state -1)
            (abbrev-mode -1)
            (setq c-basic-offset 4
                  c-recognize-colon-labels nil)
            ;; Avoid label-style electric behavior on ":" (e.g. typing std::).
            (local-set-key (kbd ":") #'self-insert-command)
            ;; Prevent `electric-indent-mode` from reindenting after ":".
            (when (listp electric-indent-chars)
              (setq-local electric-indent-chars (remq ?: electric-indent-chars)))))

;; Tree-sitter C/C++ modes use a different indent variable.
(add-hook 'c-ts-base-mode-hook
          (lambda ()
            (setq c-ts-mode-indent-offset 4)
            (when (listp electric-indent-chars)
              (setq-local electric-indent-chars (remq ?: electric-indent-chars)))))

;; ----------------------------
;; Auto-save & Backup
;; ----------------------------
;; Auto-revert files when changed externally
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)

;; Auto-save visited files
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 10)

;; Keep backups and auto-save files outside the repo-backed config directory.
(let ((backup-dir (expand-file-name "backups/" rc/state-directory))
      (autosave-dir (expand-file-name "auto-save/" rc/state-directory))
      (autosave-list-dir (expand-file-name "auto-save/sessions/" rc/state-directory)))
  (dolist (dir (list backup-dir autosave-dir autosave-list-dir))
    (make-directory dir t))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,autosave-dir t))
        auto-save-list-file-prefix (expand-file-name ".saves-" autosave-list-dir)))

(setq make-backup-files t
      backup-by-copying t
      delete-old-versions t
      version-control t
      kept-new-versions 10
      kept-old-versions 2
      auto-save-default t
      auto-save-no-message t
      create-lockfiles nil)

;; ----------------------------
;; Clipboard & Selection
;; ----------------------------
(setq select-enable-clipboard t
      select-active-regions nil
      select-enable-primary t
      mouse-drag-copy-region nil)

;; ----------------------------
;; Startup
;; ----------------------------
(setq inhibit-startup-message t
      initial-scratch-message nil)

;; ----------------------------
;; Misc
;; ----------------------------
;; Use short answers (y/n instead of yes/no)
(setq use-short-answers t)
;; dired dwim
(setq dired-dwim-target t)

;;; editor.el ends here
