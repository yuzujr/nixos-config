;;; lsp.el -*- lexical-binding: t; -*-

(provide 'lsp)

(require 'subr-x)

;; Keep IPC throughput high for LSP payloads.
(setq read-process-output-max (* 1024 1024))

;; Eglot uses yasnippet to expand snippet-style LSP completions.
(use-package yasnippet
  :custom
  (yas-snippet-dirs (list (expand-file-name "snippets/" user-emacs-directory)))
  :hook (prog-mode . yas-minor-mode)
  :config
  (make-directory (car yas-snippet-dirs) t)
  (yas-reload-all))

(use-package xref
  :ensure nil
  :bind (("C-c d" . xref-find-definitions)
         ("C-c u" . xref-find-references)))

(use-package flymake
  :ensure nil)

(defun rc/sideline-flymake-diagnostic-text (diag)
  "Return a short displayable string for Flymake diagnostic DIAG."
  (let ((text (or (ignore-errors
                    (flymake-diagnostic-text diag '(origin code oneliner)))
                  (ignore-errors
                    (flymake-diagnostic-message diag)))))
    (when (and (stringp text)
               (not (string-empty-p text)))
      (setq text (replace-regexp-in-string "[\n\t ]+" " " text))
      (truncate-string-to-width text 90 nil nil (truncate-string-ellipsis)))))

(defun rc/sideline-flymake-candidate (diag)
  "Return a propertized sideline candidate for Flymake diagnostic DIAG."
  (when-let* ((text (rc/sideline-flymake-diagnostic-text diag)))
    (let* ((type (sideline-flymake--get-level (flymake-diagnostic-type diag)))
           (face (pcase type
                   ('error 'sideline-flymake-error)
                   ('warning 'sideline-flymake-warning)
                   ('note 'sideline-flymake-note)))
           (prefix (or (pcase type
                         ('error sideline-flymake-error-prefix)
                         ('warning sideline-flymake-warning-prefix)
                         ('note sideline-flymake-note-prefix))
                       ""))
           (text (concat prefix text)))
      (when sideline-flymake-show-backend-name
        (setq text (format "%s (%s)" text (flymake-diagnostic-backend diag))))
      (add-face-text-property 0 (length text) face nil text)
      text)))

(defun rc/sideline-flymake-show-errors (callback &rest _)
  "Display Flymake diagnostics with nil-safe sideline candidates."
  (when flymake-mode
    (when-let* ((candidates (delq nil
                                  (mapcar #'rc/sideline-flymake-candidate
                                          (sideline-flymake--get-errors)))))
      (funcall callback candidates))))

(use-package sideline
  :hook (flymake-mode . sideline-mode)
  :custom
  (sideline-backends-right-skip-current-line nil)
  :config
  (require 'sideline-flymake)
  (setq sideline-backends-right '(sideline-flymake)
        sideline-flymake-display-mode 'line)
  (unless (advice-member-p #'rc/sideline-flymake-show-errors
                           'sideline-flymake--show-errors)
    (advice-add 'sideline-flymake--show-errors
                :override #'rc/sideline-flymake-show-errors)))

(use-package sideline-flymake
  :after sideline
  :commands (sideline-flymake))

(defun rc/eglot-format-buffer-on-save ()
  "Format current buffer with Eglot before saving when supported."
  (when (and (eglot-managed-p)
             (eglot-server-capable :documentFormattingProvider))
    (eglot-format-buffer)))

(defun rc/eglot-enable-format-on-save ()
  "Enable Eglot formatting before saving in the current buffer."
  (add-hook 'before-save-hook #'rc/eglot-format-buffer-on-save nil t))

(use-package eglot
  :ensure nil
  :hook ((python-ts-mode . eglot-ensure)
         (c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure)
         (eglot-managed-mode . rc/eglot-enable-format-on-save))
  :bind (("C-c a" . eglot-code-actions)
         ("C-c r" . eglot-rename)
         ("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)
         ("C-c l s" . eglot)
         ("C-c l c" . eglot-reconnect)
         ("C-c l q" . eglot-shutdown)
         ("C-c l o" . eglot-code-action-organize-imports)
         ("C-c l f" . eglot-format-buffer)
         ("C-c l i" . eglot-find-implementation)
         ("C-c l t" . xref-find-type-definitions)
         ("C-c l b" . eldoc-doc-buffer))
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  (eglot-send-changes-idle-time 0.1)
  (eglot-events-buffer-size 0)
  :config
  (add-to-list 'eglot-server-programs '((nix-ts-mode) . ("nixd"))))

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "C-c d" "definition"
    "C-c u" "references"
    "C-c l" "lsp"))

;;; lsp.el ends here
