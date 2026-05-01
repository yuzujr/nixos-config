;;; init.el -*- lexical-binding: t; -*-

;; ----------------------------
;; Init Helpers
;; ----------------------------
(eval-and-compile
  (require 'use-package))
(setq use-package-always-ensure nil)

(use-package benchmark-init
  :demand t
  :config
  ;; Start collecting before the rest of the config loads.
  (benchmark-init/activate)
  :hook
  ;; Stop collecting after startup to avoid runtime overhead.
  (after-init . benchmark-init/deactivate))

;; ----------------------------
;; Load Configuration Modules
;; ----------------------------
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))

;; Keep Customize output in a tracked config file.
(setq custom-file (locate-user-emacs-file "config/custom.el"))

;; Load modular configuration
(require 'editor)       ; Basic editor settings
(require 'org-config)   ; Org mode and Babel
(require 'ui)           ; UI and appearance
(require 'completion)   ; Completion framework (Vertico)
(require 'lsp)          ; Eglot (LSP client)
(require 'programming)  ; Programming modes and tools
(require 'tools)        ; Utility packages
(require 'functions)    ; Custom functions

;; Load Customize output after module defaults so UI changes made through
;; Emacs don't get silently overridden by the base config on startup.
(load custom-file t)

;; ----------------------------
;; Post-Startup Optimization
;; ----------------------------
;; Restore GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 128 1024 1024)  ; 128MB
                  gc-cons-percentage 0.2)))

;;; init.el ends here
