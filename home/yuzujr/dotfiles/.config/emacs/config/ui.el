;;; ui.el -*- lexical-binding: t; -*-

(provide 'ui)
(require 'subr-x)

;; ----------------------------
;; Font Configuration
;; ----------------------------
(defvar font-family "Maple Mono NF CN"
  "Default font family.")

(defvar font-height 120
  "Default font height (1/10 pt).")

(defvar font-weight 'regular
  "Default font weight.")

(defvar font-slant 'normal
  "Default font slant.")

(set-face-attribute 'default nil
                    :family font-family
                    :height font-height
                    :weight font-weight
                    :slant  font-slant)

;; ----------------------------
;; Theme (solarized)
;; ----------------------------
(defvar rc/theme-dark 'solarized-dark)
(defvar rc/theme-light 'solarized-light)
(defvar rc/current-theme nil)
(defvar rc/theme-monitor-proc nil)

(defun rc/theme-apply (theme)
  (unless (eq theme rc/current-theme)
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)
    (setq rc/current-theme theme)))

(defun rc/theme--apply-scheme (scheme)
  (when scheme
    (rc/theme-apply (if (eq scheme 'light) rc/theme-light rc/theme-dark))))

(defun rc/theme--portal-read-scheme ()
  ;; your machine output: (<<uint32 2>>,)
  (let ((out (string-trim
              (shell-command-to-string
               "gdbus call --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop --method org.freedesktop.portal.Settings.Read org.freedesktop.appearance color-scheme 2>/dev/null"))))
    (cond
     ((string-match-p "(<<uint32 1>>" out) 'dark)
     ((string-match-p "(<<uint32 2>>" out) 'light)
     (t nil))))

(defun rc/theme-stop-portal-monitor ()
  (interactive)
  (when (process-live-p rc/theme-monitor-proc)
    (ignore-errors (kill-process rc/theme-monitor-proc)))
  (setq rc/theme-monitor-proc nil))

(add-hook 'kill-emacs-hook #'rc/theme-stop-portal-monitor)

(defun rc/theme-start-portal-monitor ()
  (interactive)
  (rc/theme-stop-portal-monitor)

  ;; 启动先读一次
  (rc/theme--apply-scheme (rc/theme--portal-read-scheme))

  ;; 监听：
  ;; SettingChanged ('org.freedesktop.appearance', 'color-scheme', <uint32 1|2>)
  (setq rc/theme-monitor-proc
        (make-process
         :name "rc-theme-portal-monitor"
         :buffer " *rc-theme-portal*"
         :command '("gdbus" "monitor" "--session"
                    "--dest" "org.freedesktop.portal.Desktop"
                    "--object-path" "/org/freedesktop/portal/desktop")
         :noquery t
         :filter
         (lambda (_proc chunk)
           (dolist (line (split-string chunk "\n" t))
             (when (and (string-match-p "org\\.freedesktop\\.appearance" line)
                        (string-match-p "color-scheme" line))
               (cond
                ((string-match-p "<uint32 1>" line) (rc/theme--apply-scheme 'dark))
                ((string-match-p "<uint32 2>" line) (rc/theme--apply-scheme 'light)))))))))

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
              split-width-threshold   120) ; the reasonable limit for horizontal splits

;;; ui.el ends here
