;;; ai.el -*- lexical-binding: t; -*-

(provide 'ai)

(declare-function rc/context-buffer-directory "context" (&optional buffer))
(declare-function rc/context-directory "context" (&optional fallback))
(declare-function rc/context-project-root "context" (&optional dir))

;; ----------------------------
;; AI Agent Coding - ai-code-interface.el + Codex CLI
;; ----------------------------

(defun rc/ai--context-directory ()
  "Return best-effort directory context for AI project detection."
  (or
   (rc/context-buffer-directory (current-buffer))
   ;; If currently in AI terminal buffer, fall back to recently visited buffer.
   (rc/context-buffer-directory (other-buffer (current-buffer) t))
   (rc/context-directory)))

(defun rc/ai--project-root (&optional dir)
  "Return a stable Treemacs-aware root for AI session lookup."
  (rc/context-project-root (or dir (rc/ai--context-directory))))

(defun rc/ai--ensure-codex ()
  "Ensure ai-code backend is codex."
  (require 'ai-code)
  (unless (eq ai-code-selected-backend 'codex)
    (ai-code-set-backend 'codex)))

(defun rc/ai-resume ()
  "Resume Codex session using the current command context as lookup key."
  (interactive)
  (rc/ai--ensure-codex)
  (let ((default-directory (expand-file-name (rc/ai--project-root))))
    (call-interactively #'ai-code-cli-resume)))

(defun rc/ai--session-working-directory-advice (orig-fn &rest _args)
  "Return stable project root for ai-code sessions, fallback to ORIG-FN."
  (let ((root (rc/ai--project-root)))
    (if (and root (file-directory-p root))
        (expand-file-name root)
      (apply orig-fn _args))))

(use-package ai-code
  :bind (("C-c C-a" . ai-code-menu)
         ("C-c C-z" . rc/ai-resume))
  :custom
  ;; Use Codex CLI as backend runtime.
  (ai-code-codex-cli-program "codex")
  ;; Keep terminal sessions inside vterm.
  (ai-code-backends-infra-terminal-backend 'vterm)
  ;; Default window width
  (ai-code-backends-infra-window-width 72)
  :config
  (ai-code-set-backend 'codex)
  (ai-code-prompt-filepath-completion-mode 1)
  (with-eval-after-load 'ai-code-backends-infra
    ;; Make start/resume/switch from ai-code menu use the same robust project root.
    (advice-remove 'ai-code-backends-infra--session-working-directory
                   #'rc/ai--session-working-directory-advice)
    (advice-add 'ai-code-backends-infra--session-working-directory :around
                #'rc/ai--session-working-directory-advice))
  (unless (executable-find ai-code-codex-cli-program)
    (message "[ai-code] codex CLI not found in PATH: %s"
             ai-code-codex-cli-program))
  (with-eval-after-load 'which-key
    (which-key-add-key-based-replacements
      "C-c C-a" "ai-menu"
      "C-c C-z" "ai-resume")))

;;; ai.el ends here
