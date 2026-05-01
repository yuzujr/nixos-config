;;; lsp.el -*- lexical-binding: t; -*-

(provide 'lsp)

;; Keep IPC throughput high for LSP payloads.
(setq read-process-output-max (* 1024 1024))

;; Eglot expands LSP snippets through yasnippet.
(use-package yasnippet
  :custom
  (yas-snippet-dirs (list (expand-file-name "snippets/" user-emacs-directory)))
  :hook (prog-mode . yas-minor-mode)
  :bind (("C-c y e" . yas-expand)
         ("C-c y i" . yas-insert-snippet)
         ("C-c y v" . yas-visit-snippet-file)
         ("C-c y r" . yas-reload-all)
         ("C-c y n" . yas-new-snippet))
  :config
  (make-directory (car yas-snippet-dirs) t)
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package flymake
  :ensure nil)

(use-package eglot
  :ensure nil
  :hook ((python-ts-mode . eglot-ensure)
         (c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure))
  :bind (("C-c a" . eglot-code-actions)
         ("C-c r" . eglot-rename)
         ("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)
         ("C-c e" . eldoc-box-help-at-point)
         ("C-c l s" . eglot)
         ("C-c l c" . eglot-reconnect)
         ("C-c l q" . eglot-shutdown)
         ("C-c l o" . eglot-code-action-organize-imports)
         ("C-c l f" . eglot-format-buffer)
         ("C-c l i" . eglot-find-implementation)
         ("C-c l t" . xref-find-type-definitions)
         ("C-c l b" . eldoc-doc-buffer)
         ("C-c l e" . eglot-events-buffer))
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  (eglot-send-changes-idle-time 0.1)
  (eglot-events-buffer-size 0)
  :config
  (add-to-list 'eglot-server-programs '((nix-ts-mode) . ("nixd"))))

(use-package eldoc-box
  :after eglot
  ;; :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode)
  :custom
  (eldoc-box-only-multi-line t)
  (eldoc-box-cleanup-interval 1.0)
  (eldoc-box-max-pixel-width 1100)
  (eldoc-box-max-pixel-height 700))

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "C-c l" "lsp"
    "C-c y" "snippets"))

;;; lsp.el ends here
