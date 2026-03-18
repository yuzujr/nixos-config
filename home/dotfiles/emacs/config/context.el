;;; context.el -*- lexical-binding: t; -*-

(require 'project)
(require 'subr-x)

(defcustom rc/context-prefer-treemacs t
  "When non-nil, prefer the current Treemacs directory for command context."
  :type 'boolean
  :group 'convenience)

(defun rc/context--normalize-directory (dir)
  "Return DIR as an expanded directory path, or nil when unusable."
  (when (and (stringp dir) (not (string-empty-p dir)))
    (let ((expanded (expand-file-name dir)))
      (when (file-directory-p expanded)
        expanded))))

(defun rc/context-buffer-directory (&optional buffer)
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

(defun rc/context--treemacs-directory-at-point ()
  "Return the current directory selected in Treemacs, or nil."
  (when (and rc/context-prefer-treemacs
             (featurep 'treemacs)
             (fboundp 'treemacs-get-local-buffer)
             (fboundp 'treemacs-current-button)
             (fboundp 'treemacs-button-get))
    (when-let* ((buffer (ignore-errors (treemacs-get-local-buffer)))
                ((buffer-live-p buffer)))
      (with-current-buffer buffer
        (when-let* ((button (ignore-errors (treemacs-current-button)))
                    (path (ignore-errors (treemacs-button-get button :path))))
          (rc/context--normalize-directory
           (if (file-directory-p path)
               path
             (file-name-directory path))))))))

(defun rc/context--treemacs-workspace-directory ()
  "Return the current Treemacs workspace directory when it is unambiguous."
  (when (and rc/context-prefer-treemacs
             (featurep 'treemacs)
             (fboundp 'treemacs-current-workspace)
             (fboundp 'treemacs-workspace->projects)
             (fboundp 'treemacs-project->path))
    (when-let* ((workspace (ignore-errors (treemacs-current-workspace)))
                (projects (ignore-errors (treemacs-workspace->projects workspace)))
                ((= (length projects) 1))
                (project (car projects)))
      (rc/context--normalize-directory
       (treemacs-project->path project)))))

(defun rc/context-treemacs-directory ()
  "Return the best available Treemacs directory context."
  (or (rc/context--treemacs-directory-at-point)
      (rc/context--treemacs-workspace-directory)))

(defun rc/context-directory (&optional fallback)
  "Return the preferred directory for commands."
  (or (rc/context-treemacs-directory)
      (rc/context-buffer-directory (current-buffer))
      (rc/context--normalize-directory fallback)
      (expand-file-name "~")))

(defun rc/context-project-root (&optional dir)
  "Return a stable project root for DIR."
  (let* ((dir (or (rc/context--normalize-directory dir)
                  (rc/context-directory)))
         (truename (ignore-errors (file-truename dir))))
    (or
     (when-let ((project (ignore-errors (project-current nil dir))))
       (project-root project))
     (and truename
          (when-let ((project (ignore-errors (project-current nil truename))))
            (project-root project)))
     (locate-dominating-file dir ".git")
     (and truename
          (locate-dominating-file truename ".git"))
     (locate-dominating-file dir "AGENTS.md")
     dir)))

(provide 'context)

;;; context.el ends here
