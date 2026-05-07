;;; completion.el -*- lexical-binding: t; -*-

(provide 'completion)

(defvar rc/state-directory)

;; ----------------------------
;; Vertico - Vertical Completion UI
;; ----------------------------
(use-package vertico
  :demand t
  :custom
  (vertico-cycle t)
  (vertico-resize nil)
  :config
  (vertico-mode))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; In-buffer completion UI (community mainstream with Eglot).
(use-package corfu
  :demand t
  :bind (:map corfu-map
              ("RET" . nil)
              ("<return>" . nil)
              ("TAB" . corfu-insert)
              ("M-SPC" . corfu-insert-separator)
              ("M-d" . corfu-popupinfo-documentation)
              ("M-l" . corfu-popupinfo-location))
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.08)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator)
  (corfu-preview-current nil)
  :config
  (global-corfu-mode))

(use-package corfu-popupinfo
  :after corfu
  :config
  (corfu-popupinfo-mode 1))

;; Persist minibuffer history across sessions.
(use-package savehist
  :custom
  (savehist-file (expand-file-name "savehist" rc/state-directory))
  (history-length 1000)
  (history-delete-duplicates t)
  (savehist-autosave-interval 300)
  (savehist-additional-variables '(extended-command-history))
  :config
  (savehist-mode 1))

;; Frequency/recency-based sorting for completion candidates.
(use-package prescient
  :after savehist
  :custom
  (prescient-history-length 1000)
  (prescient-save-file (expand-file-name "prescient-save.el" rc/state-directory))
  :config
  (prescient-persist-mode 1))

(use-package vertico-prescient
  :after (vertico prescient)
  :custom
  ;; Keep orderless matching behavior and only replace sorting.
  (vertico-prescient-enable-filtering nil)
  :config
  (vertico-prescient-mode 1))

(use-package corfu-prescient
  :after (corfu prescient)
  :config
  (corfu-prescient-mode 1))

;; ----------------------------
;; Orderless - Flexible Matching
;; ----------------------------
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; ----------------------------
;; Marginalia - Rich Annotations
;; ----------------------------
(use-package marginalia
  :demand t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :config
  (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-c b" . consult-buffer)
         ("C-c F" . consult-fd)
         ("C-c s" . consult-ripgrep)
         ("C-c /" . consult-line)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-y" . consult-yank-pop))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :custom
  (consult-narrow-key "<")
  ;; Avoid default `#` separator prompt in async commands.
  (consult-async-split-style 'semicolon))

(use-package consult-flymake
  :ensure nil
  :bind (("C-c n" . consult-flymake)))

(use-package consult-imenu
  :ensure nil
  :bind (("C-c i" . consult-imenu)))

(use-package consult-xref
  :ensure nil
  :commands (consult-xref)
  :init
  (with-eval-after-load 'xref
    (setq xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)))

;;; completion.el ends here
