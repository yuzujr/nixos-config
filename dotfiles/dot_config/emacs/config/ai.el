;;; ai.el -*- lexical-binding: t; -*-

(provide 'ai)

;; ----------------------------
;; AI Agent Coding - ai-code-interface.el + Codex CLI
;; ----------------------------

(defun rc/ai--buffer-directory (&optional buffer)
  "Return a usable directory for BUFFER, or nil."
  (when (buffer-live-p buffer)
    (with-current-buffer buffer
      (cond
       (buffer-file-name
        (file-name-directory (expand-file-name buffer-file-name)))
       ((derived-mode-p 'dired-mode)
        (when (and (boundp 'dired-directory) dired-directory)
          (expand-file-name
           (if (stringp dired-directory)
               dired-directory
             default-directory))))
       ((and default-directory (file-directory-p default-directory))
        (expand-file-name default-directory))
       (t nil)))))

(defun rc/ai--context-directory ()
  "Return best-effort directory context for AI project detection."
  (or
   (rc/ai--buffer-directory (current-buffer))
   ;; If currently in AI terminal buffer, fall back to recently visited buffer.
   (rc/ai--buffer-directory (other-buffer (current-buffer) t))
   (and default-directory (expand-file-name default-directory))
   (expand-file-name "~")))

(defun rc/ai--project-root (&optional dir)
  "Return a stable project root for AI session lookup."
  (let* ((start-dir (expand-file-name (or dir (rc/ai--context-directory))))
         (start-truename (ignore-errors (file-truename start-dir))))
    (or
     ;; Prefer git root, including symlink-resolved path.
     (locate-dominating-file start-dir ".git")
     (and start-truename (locate-dominating-file start-truename ".git"))
     ;; Fall back to project.el root from explicit directory.
     (when-let ((project (ignore-errors (project-current nil start-dir))))
       (project-root project))
     (and start-truename
          (when-let ((project (ignore-errors (project-current nil start-truename))))
            (project-root project)))
     (locate-dominating-file start-dir "AGENTS.md")
     (when (file-in-directory-p start-dir user-emacs-directory)
        user-emacs-directory)
     start-dir)))

(defun rc/ai--ensure-codex ()
  "Ensure ai-code backend is codex."
  (require 'ai-code)
  (unless (eq ai-code-selected-backend 'codex)
    (ai-code-set-backend 'codex)))

(defun rc/ai-resume ()
  "Resume Codex session using project root as lookup key."
  (interactive)
  (rc/ai--ensure-codex)
  (let ((default-directory (expand-file-name (rc/ai--project-root))))
    (call-interactively #'ai-code-cli-resume)))

(defun rc/ai-switch ()
  "Switch to Codex session buffer using project root as lookup key."
  (interactive)
  (rc/ai--ensure-codex)
  (let ((default-directory (expand-file-name (rc/ai--project-root))))
    (call-interactively #'ai-code-cli-switch-to-buffer)))

(defun rc/ai--session-working-directory-advice (orig-fn &rest _args)
  "Return stable project root for ai-code sessions, fallback to ORIG-FN."
  (let ((root (rc/ai--project-root)))
    (if (and root (file-directory-p root))
        (expand-file-name root)
      (funcall orig-fn))))

(defun rc/ai-hide ()
  "Hide all visible AI session windows."
  (interactive)
  (require 'ai-code-backends-infra)
  (let ((hidden nil))
    (dolist (win (window-list))
      (let ((buf (window-buffer win)))
        (when (ai-code-backends-infra--session-buffer-p buf)
          (setq hidden t)
          (quit-window nil win))))
    (unless hidden
      (message "No visible AI window to hide"))))

(defvar rc/ai-session-text-scale 0
  "Text scale for ai-code session buffers.")

(defvar rc/ai-prompt-text-scale 0
  "Text scale for ai-code prompt buffers.")

(defun rc/ai--apply-session-text-scale ()
  "Apply `rc/ai-session-text-scale' in ai-code session buffers."
  (when (and (numberp rc/ai-session-text-scale)
             (fboundp 'ai-code-backends-infra--session-buffer-p)
             (ai-code-backends-infra--session-buffer-p (current-buffer)))
    (text-scale-set rc/ai-session-text-scale)))

(defun rc/ai--apply-prompt-text-scale ()
  "Apply `rc/ai-prompt-text-scale' in ai-code prompt buffers."
  (when (numberp rc/ai-prompt-text-scale)
    (text-scale-set rc/ai-prompt-text-scale)))

(use-package ai-code
  :bind (("C-c C-a" . ai-code-menu)
         ("C-c C-z" . rc/ai-resume)
         ("C-c z" . rc/ai-switch)
         ("C-c q" . rc/ai-hide))
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
  (with-eval-after-load 'vterm
    (add-hook 'vterm-mode-hook #'rc/ai--apply-session-text-scale))
  (with-eval-after-load 'ai-code-prompt-mode
    (add-hook 'ai-code-prompt-mode-hook #'rc/ai--apply-prompt-text-scale))
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
      "C-c C-z" "ai-resume"
      "C-c z" "ai-switch"
      "C-c q" "ai-hide")))

;;; ai.el ends here
