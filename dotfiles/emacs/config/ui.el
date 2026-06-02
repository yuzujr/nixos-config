;;; ui.el -*- lexical-binding: t; -*-

(provide 'ui)

;; ----------------------------
;; Font Configuration
;; ----------------------------
(defcustom rc/font-family "Maple Mono NF CN"
  "Default font family.")

(defcustom rc/font-height 130
  "Default font hei/ght (1/10 pt).")

(defcustom rc/font-weight 'regular
  "Default font weight.")

(defcustom rc/font-slant 'normal
  "Default font slant.")

(defun rc/set-default-frame-parameter (parameter value)
  "Set default frame PARAMETER to VALUE for current and future frames."
  (setf (alist-get parameter default-frame-alist) value)
  (setf (alist-get parameter initial-frame-alist) value))

(defun rc/apply-fonts (&optional frame)
  "Apply configured fonts to FRAME."
  (when (display-graphic-p (or frame (selected-frame)))
    (set-face-attribute 'default frame
                        :family rc/font-family
                        :height rc/font-height
                        :weight rc/font-weight
                        :slant rc/font-slant)))

(add-hook 'after-make-frame-functions #'rc/apply-fonts)
(rc/apply-fonts)

;; ----------------------------
;; Theme
;; ----------------------------
(defvar rc/doom-rose-pine-dir (expand-file-name "elpa/rose-pine-doom-emacs" user-emacs-directory))
(defvar rc/theme-dark 'doom-rose-pine)
(defvar rc/theme-light 'doom-rose-pine-dawn)
(defvar rc/current-theme nil)
(defvar rc/initial-color-scheme 'dark)

(defun rc/theme-apply (theme)
  (unless (eq theme rc/current-theme)
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)
    (setq rc/current-theme theme)))

(defun rc/theme-apply-initial ()
  (interactive)
  (rc/theme-apply (if (eq rc/initial-color-scheme 'light)
                      rc/theme-light
                    rc/theme-dark)))

(unless (file-exists-p rc/doom-rose-pine-dir)
  (message "Downloading Doom Rosé Pine theme...")
  (call-process "git" nil nil nil "clone" "https://github.com/donniebreve/rose-pine-doom-emacs.git" rc/doom-rose-pine-dir))
(add-to-list 'custom-theme-load-path rc/doom-rose-pine-dir)
(rc/theme-apply-initial)

;; ----------------------------
;; Centered Editing
;; ----------------------------
(use-package olivetti
  :hook (prog-mode . olivetti-mode)
  :custom
  (olivetti-body-width 120))

;; ----------------------------
;; Window Display
;; ----------------------------
;; Line numbers
(global-display-line-numbers-mode 1)

;; Smooth scrolling
(setq scroll-margin 5
      scroll-conservatively 101
      ; mouse-wheel-progressive-speed nil
      fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t)

;; ----------------------------
;; Window Splitting Behavior
;; ----------------------------
(with-eval-after-load "window"
  (defun rc/frame-live-windows (&optional frame)
    "Return live non-minibuffer windows on FRAME."
    (let (windows)
      (walk-windows
       (lambda (window)
         (unless (window-minibuffer-p window)
           (push window windows)))
       nil
       (or frame (selected-frame)))
      (nreverse windows)))

  (defun rc/right-stack-window (&optional frame)
    "Return the bottom-most window in FRAME's rightmost column."
    (let ((target nil)
          (rightmost-left nil))
      (dolist (window (rc/frame-live-windows frame))
        (let ((left (car (window-edges window)))
              (top (cadr (window-edges window))))
          (when (or (null rightmost-left)
                    (> left rightmost-left)
                    (and (= left rightmost-left)
                         (or (null target)
                             (> top (cadr (window-edges target))))))
            (setq rightmost-left left
                  target window))))
      target))

  (defun split-window-sensibly
      (&optional window)
    "Split WINDOW like a master/stack tiling layout.
If there is only one live window, create a new window on the right.
Otherwise, keep stacking new windows below the bottom-most window in
the rightmost column."
    (setq window (or window (selected-window)))
    (let* ((frame (window-frame window))
           (live-windows (rc/frame-live-windows frame))
           (stack-window (rc/right-stack-window frame)))
      (if (= (length live-windows) 1)
          (or (and (window-splittable-p window t)
                   (split-window window nil 'right))
              (and (window-splittable-p window)
                   (split-window window nil 'below)))
        (or (and stack-window
                 (window-splittable-p stack-window)
                 (split-window stack-window nil 'below))
            (and (window-splittable-p window)
                 (split-window window nil 'below))
            (and (window-splittable-p window t)
                 (split-window window nil 'right))
            (and (eq window (frame-root-window frame))
                 (not (window-minibuffer-p window))
                 (let ((split-height-threshold 0))
                   (when (window-splittable-p window)
                     (split-window window nil 'below))))))))

  (setq split-window-preferred-function #'split-window-sensibly)

  (setq-default split-height-threshold  4
                split-width-threshold   100))

;;; ui.el ends here
