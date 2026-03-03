;;; completion.el -*- lexical-binding: t; -*-

(provide 'completion)

;; ----------------------------
;; Vertico - Vertical Completion UI
;; ----------------------------
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-resize nil))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package vertico-repeat
  :ensure nil
  :after vertico
  :init
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  :bind (("C-c c v" . vertico-repeat)
         :map vertico-map
         ("M-p" . vertico-repeat-previous)
         ("M-n" . vertico-repeat-next)))

;; In-buffer completion UI (community mainstream with Eglot).
(use-package corfu
  :init
  (global-corfu-mode)
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
  (corfu-popupinfo-mode 1))

;; Persist minibuffer history across sessions.
(use-package savehist
  :init
  (savehist-mode 1)
  :custom
  (history-length 1000)
  (history-delete-duplicates t)
  (savehist-autosave-interval 300)
  (savehist-additional-variables '(extended-command-history)))

;; Frequency/recency-based sorting for completion candidates.
(use-package prescient
  :after savehist
  :custom
  (prescient-history-length 1000)
  (prescient-save-file (locate-user-emacs-file "prescient-save.el"))
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
  :init
  (marginalia-mode)
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle)))

;; ----------------------------
;; Consult - Enhanced Commands
;; ----------------------------
(use-package consult
  :bind (;; Canonical keymap (no legacy compatibility bindings)
         ("C-c b" . consult-buffer)
         ("C-c f" . consult-fd)
         ("C-c F" . consult-locate)
         ("C-c s" . consult-ripgrep)
         ("C-c /" . consult-line)
         ("C-c c g" . consult-goto-line)
         ("C-c c o" . consult-outline)
         ("C-c c e" . consult-compile-error)
         ("C-c c n" . consult-flymake)
         ("C-c c h" . consult-history)
         ("C-c c m" . consult-mode-command)
         ("C-c c k" . consult-kmacro)
         ("C-c c y" . consult-yank-pop)
         ("C-c c x" . consult-bookmark))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :custom
  (consult-narrow-key "<")
  ;; Avoid default `#` separator prompt in async commands.
  (consult-async-split-style 'semicolon))

;; ----------------------------
;; Consult-dir - Directory Sources for Minibuffer
;; ----------------------------
(use-package consult-dir
  :after (consult vertico)
  :bind (:map vertico-map
         ("M-g" . consult-dir)))

(with-eval-after-load 'which-key
  (which-key-add-key-based-replacements
    "C-c c i" "consult-dir"
    "C-c c j" "consult-dir-file"))

;; ----------------------------
;; Embark - Contextual Actions
;; ----------------------------
(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :custom
  (prefix-help-command #'embark-prefix-help-command)
  :config
  ;; In Embark file actions, use `U` to open the target file via sudo-edit.
  (keymap-set embark-file-map "U" #'sudo-edit-find-file))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;; completion.el ends here
