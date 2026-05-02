;;; ui.el -*- lexical-binding: t; -*-

(provide 'ui)
(require 'dbus nil t)
(require 'subr-x)

;; ----------------------------
;; Font Configuration
;; ----------------------------
(defcustom rc/font-family "Maple Mono NF CN"
  "Default font family.")

(defcustom rc/font-height 120
  "Default font hei/ght (1/10 pt).")

(defcustom rc/font-weight 'regular
  "Default font weight.")

(defcustom rc/font-slant 'normal
  "Default font slant.")

(defcustom rc/frame-opacity 100
  "Default frame opacity percentage."
  :type 'integer)

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

(defun rc/apply-frame-opacity (&optional frame)
  "Apply configured opacity to FRAME."
  (let ((frame (or frame (selected-frame)))
        (alpha `(,rc/frame-opacity . ,rc/frame-opacity)))
    (when (display-graphic-p frame)
      (rc/set-default-frame-parameter 'alpha-background rc/frame-opacity)
      (rc/set-default-frame-parameter 'alpha alpha)
      (set-frame-parameter frame 'alpha-background rc/frame-opacity)
      (set-frame-parameter frame 'alpha alpha))))

(add-hook 'after-make-frame-functions #'rc/apply-fonts)
(add-hook 'after-make-frame-functions #'rc/apply-frame-opacity)
(rc/apply-fonts)
(rc/apply-frame-opacity)

;; ----------------------------
;; Theme (solarized)
;; ----------------------------
(defvar rc/theme-dark 'solarized-dark)
(defvar rc/theme-light 'solarized-light)
(defvar rc/current-theme nil)
(defvar rc/theme-monitor nil)

(defun rc/theme-apply (theme)
  (unless (eq theme rc/current-theme)
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)
    (setq rc/current-theme theme)))

(defun rc/theme--apply-scheme (scheme)
  (when scheme
    (rc/theme-apply (if (eq scheme 'light) rc/theme-light rc/theme-dark))))

(defun rc/theme--scheme-from-value (value)
  "Extract a portal light/dark value from VALUE."
  (cond
   ((eq value 1) 'dark)
   ((eq value 2) 'light)
   ((consp value)
    (or (rc/theme--scheme-from-value (car value))
        (rc/theme--scheme-from-value (cdr value))))
   (t nil)))

(defun rc/theme--portal-read-scheme ()
  "Return the current desktop color scheme, or nil when unavailable."
  (when (and (display-graphic-p)
             (featurep 'dbusbind))
    (condition-case nil
        (rc/theme--scheme-from-value
         (dbus-call-method
          :session
          "org.freedesktop.portal.Desktop"
          "/org/freedesktop/portal/desktop"
          "org.freedesktop.portal.Settings"
          "Read"
          "org.freedesktop.appearance"
          "color-scheme"))
      (error nil))))

(defun rc/theme--portal-signal-handler (_namespace _key value)
  "Apply a new theme after a portal SettingChanged signal VALUE."
  (when-let ((scheme (rc/theme--scheme-from-value value)))
    (rc/theme--apply-scheme scheme)))

(defun rc/theme-stop-portal-monitor ()
  (interactive)
  (when rc/theme-monitor
    (ignore-errors (dbus-unregister-object rc/theme-monitor)))
  (setq rc/theme-monitor nil))

(add-hook 'kill-emacs-hook #'rc/theme-stop-portal-monitor)

(defun rc/theme-start-portal-monitor ()
  (interactive)
  (rc/theme-stop-portal-monitor)
  (rc/theme-apply rc/theme-dark)
  (when-let ((scheme (rc/theme--portal-read-scheme)))
    (rc/theme--apply-scheme scheme))
  (when (and (display-graphic-p)
             (featurep 'dbusbind))
    (setq rc/theme-monitor
          (condition-case nil
              (dbus-register-signal
               :session
               "org.freedesktop.portal.Desktop"
               "/org/freedesktop/portal/desktop"
               "org.freedesktop.portal.Settings"
               "SettingChanged"
               #'rc/theme--portal-signal-handler
               :arg0 "org.freedesktop.appearance"
               :arg1 "color-scheme")
            (error nil)))))

(use-package solarized-theme
  :config
  (rc/theme-start-portal-monitor))

;; ----------------------------
;; Window Display
;; ----------------------------
;; Line numbers
(global-display-line-numbers-mode 1)

;; Smooth scrolling
(setq scroll-margin 5
      scroll-conservatively 101
      mouse-wheel-progressive-speed nil)

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
