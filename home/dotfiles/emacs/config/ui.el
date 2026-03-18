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
(setq display-line-numbers-type 'relative)

;; Smooth scrolling
(setq scroll-margin 5
      scroll-conservatively 101
      mouse-wheel-progressive-speed nil)

;; ----------------------------
;; Window Splitting Behavior
;; ----------------------------
(with-eval-after-load "window"
  (defcustom split-window-below nil
    "If non-nil, vertical splits produce new windows below."
    :group 'windows
    :type 'boolean)

  (defcustom split-window-right nil
    "If non-nil, horizontal splits produce new windows to the right."
    :group 'windows
    :type 'boolean)

  (fmakunbound #'split-window-sensibly)

  (defun split-window-sensibly
      (&optional window)
    (setq window (or window (selected-window)))
    (or (and (window-splittable-p window t)
             ;; Split window horizontally.
             (split-window window nil (if split-window-right 'left  'right)))
        (and (window-splittable-p window)
             ;; Split window vertically.
             (split-window window nil (if split-window-below 'above 'below)))
        (and (eq window (frame-root-window (window-frame window)))
             (not (window-minibuffer-p window))
             ;; If WINDOW is the only window on its frame and is not the
             ;; minibuffer window, try to split it horizontally disregarding the
             ;; value of `split-width-threshold'.
             (let ((split-width-threshold 0))
               (when (window-splittable-p window t)
                 (split-window window nil (if split-window-right
                                              'left
                                            'right))))))))

(setq-default split-height-threshold  4
              split-width-threshold   100) ; the reasonable limit for horizontal splits

;;; ui.el ends here
