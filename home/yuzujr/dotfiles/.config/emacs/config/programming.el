;;; programming.el -*- lexical-binding: t; -*-

(provide 'programming)

;; ----------------------------
;; Tree-sitter
;; ----------------------------
;; Enable tree-sitter for supported modes
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; ----------------------------
;; Language-specific Modes
;; ----------------------------
(use-package kdl-mode
  :mode ("\\.kdl\\'" . kdl-mode))

(use-package glsl-mode
  :mode ("\\.glsl\\'" . glsl-mode)
        ("\\.vert\\'" . glsl-mode)
        ("\\.frag\\'" . glsl-mode))

(defun rc/markdown-live-preview-temp-file (&rest _)
  "Return a temporary HTML file path for markdown live preview."
  (expand-file-name
   (format "emacs-md-preview-%s.html"
           (md5 (or buffer-file-name (buffer-name))))
   temporary-file-directory))

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :custom
  (markdown-command "cmark-gfm")
  (markdown-live-preview-window-function #'markdown-live-preview-window-eww)
  (markdown-live-preview-delete-export 'delete-on-export)
  :config
  ;; Avoid exporting preview files beside the source markdown file.
  (advice-remove 'markdown-live-preview-get-filename
                 #'rc/markdown-live-preview-temp-file)
  (advice-add 'markdown-live-preview-get-filename :override
              #'rc/markdown-live-preview-temp-file))

;;; programming.el ends here

