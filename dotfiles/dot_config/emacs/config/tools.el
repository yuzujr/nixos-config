;;; tools.el -*- lexical-binding: t; -*-

(provide 'tools)

;; ----------------------------
;; Git - Magit
;; ----------------------------
(use-package magit
  :bind (("C-c g" . magit-status)
         ("C-c c d" . magit-dispatch)
         ("C-c c f" . magit-file-dispatch)))

;; ----------------------------
;; Terminal - VTerm
;; ----------------------------
(use-package vterm
  :bind (("C-c v" . vterm-other-window)))

;; ----------------------------
;; Sudo Edit - Edit as Root
;; ----------------------------
(use-package sudo-edit
  :commands (sudo-edit sudo-edit-find-file))

;; ----------------------------
;; File Tree - Treemacs
;; ----------------------------
(defun rc/treemacs--workspace-names ()
  "Return names of all treemacs workspaces."
  (mapcar #'treemacs-workspace->name (treemacs-workspaces)))

(defun rc/treemacs--unique-workspace-name (base)
  "Return a unique workspace name using BASE."
  (let* ((seed (if (and base (not (string= base ""))) base "workspace"))
         (name seed)
         (n 1)
         (names (rc/treemacs--workspace-names)))
    (while (member name names)
      (setq n (1+ n)
            name (format "%s<%d>" seed n)))
    name))

(defun rc/treemacs--activate-workspace (workspace)
  "Switch to WORKSPACE robustly, including the single-workspace edge case."
  (let ((current (treemacs-current-workspace)))
    (unless (eq current workspace)
      (pcase (treemacs-do-switch-workspace workspace)
        (`(success ,_)
         nil)
        ;; treemacs internal switch refuses when there is only one workspace.
        ;; In that case just pin the scope shelf to the target workspace.
        (`only-one-workspace
         (setf (treemacs-current-workspace) workspace))
        (`(workspace-not-found ,name)
         (user-error "Workspace not found: %s" name))
        (_
         (setf (treemacs-current-workspace) workspace))))))

(defun rc/treemacs--add-project-noninteractive (path name)
  "Add PATH as NAME into current workspace without any interactive prompt."
  (pcase (treemacs-do-add-project-to-workspace path name)
    (`(success ,_)
     t)
    (`(invalid-path ,reason)
     (user-error "Invalid path %s: %s" path reason))
    (`(invalid-name ,bad-name)
     (user-error "Invalid project name: %s" bad-name))
    (`(duplicate-project ,_)
     t)
    (`(includes-project ,_)
     t)
    (`(duplicate-name ,_)
     ;; Directory basenames can collide; keep behavior stable without prompting.
     (let ((i 2)
           (candidate nil)
           (result nil))
       (while (not result)
         (setq candidate (format "%s<%d>" name i)
               i (1+ i)
               result (treemacs-do-add-project-to-workspace path candidate))
         (pcase result
           (`(success ,_) (setq result t))
           (`(duplicate-name ,_) (setq result nil))
           (`(duplicate-project ,_) (setq result t))
           (`(includes-project ,_) (setq result t))
           (`(invalid-path ,reason)
            (user-error "Invalid path %s: %s" path reason))
           (`(invalid-name ,bad-name)
            (user-error "Invalid project name: %s" bad-name))
           (_ (user-error "Failed to add project %s to workspace" path)))))
     t)
    (_
     (user-error "Failed to add project %s to workspace" path))))

(defun rc/treemacs-open-directory-workspace ()
  "Open directory DIR as treemacs workspace, reusing existing one when possible."
  (interactive)
  (require 'treemacs)
  (require 'treemacs-workspaces)
  ;; Ensure persisted workspaces are restored before any create/switch operations.
  (treemacs-current-workspace)
  (let* ((path (treemacs-canonical-path
                (read-directory-name "Workspace directory: " default-directory nil t)))
         (existing (treemacs-find-workspace-by-path path)))
    (if existing
        (progn
          (rc/treemacs--activate-workspace existing)
          (treemacs-select-window))
      (let* ((base (file-name-nondirectory (directory-file-name path)))
             (ws-name (rc/treemacs--unique-workspace-name base)))
        (pcase (treemacs-do-create-workspace ws-name)
          (`(success ,workspace)
           ;; Important ordering: if we switch first, treemacs may render the
           ;; still-empty workspace and ask for a first project directory.
           ;; Add the selected path non-interactively first, then switch.
           (let ((treemacs-override-workspace workspace))
             (rc/treemacs--add-project-noninteractive path base))
           (rc/treemacs--activate-workspace workspace)
           (treemacs-select-window))
          (`(duplicate-name ,_)
           (user-error "Workspace name already exists: %s" ws-name))
          (`(invalid-name ,name)
           (user-error "Invalid workspace name: %s" name))
          (_
           (user-error "Failed to create treemacs workspace for: %s" path)))))))

(use-package treemacs
  :bind (("C-c t" . treemacs)
         ("C-c w" . rc/treemacs-open-directory-workspace)
         ("C-c C-w" . treemacs-switch-workspace)
         ("C-c o" . treemacs-select-window)
         ("C-c p" . treemacs-add-project-to-workspace))
  :custom
  (treemacs-width 32)
  (treemacs-width-is-initially-locked nil)
  (treemacs-text-scale 0)
  (treemacs-follow-after-init t)
  :config
  ;; Disable git integration to avoid spawning python for status parsing.
  (treemacs-git-mode -1)
  (treemacs-filewatch-mode 1)
  (treemacs-follow-mode 1))

(use-package nerd-icons)

(use-package treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

;; ----------------------------
;; Editing Enhancements
;; ----------------------------
;; Move lines/regions up and down
(use-package move-text
  :bind (("M-<up>" . move-text-up)
         ("M-<down>" . move-text-down)))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-dwim)
         ("C-c C->"     . mc/mark-all-dwim))
  :custom
  (mc/always-run-for-all t))

;; Window management
(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; ----------------------------
;; Help System Enhancement
;; ----------------------------
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c h" . helpful-at-point)))

;; ----------------------------
;; Which-key - Display Keybindings
;; ----------------------------
(use-package which-key
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.5)
  (which-key-sort-order 'which-key-key-order-alpha)
  :config
  (which-key-add-key-based-replacements
    "C-c c" "extra"
    "C-c w" "tree-open-ws-dir"
    "C-c C-w" "tree-switch-ws"
    "C-c t" "tree-toggle"
    "C-c o" "tree-focus-dir"
    "C-c p" "tree-add-project"
    "C-c l" "lsp-extra"
    "C-c y" "snippets"
    "C-c ?" "cheatsheet"))

;;; tools.el ends here
