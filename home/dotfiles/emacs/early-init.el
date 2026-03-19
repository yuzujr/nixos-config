;;; early-init.el -*- lexical-binding: t; -*-

;; ----------------------------
;; Performance: Startup GC threshold
;; ----------------------------
;; Defer garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; ----------------------------
;; XDG Data Directories
;; ----------------------------
(defconst rc/cache-directory
  (expand-file-name
   "emacs/"
   (or (getenv "XDG_CACHE_HOME")
       (expand-file-name "~/.cache/")))
  "Directory for Emacs cache files.")

(defconst rc/data-directory
  (expand-file-name
   "emacs/"
   (or (getenv "XDG_DATA_HOME")
       (expand-file-name "~/.local/share/")))
  "Directory for Emacs data files.")

(defconst rc/state-directory
  (expand-file-name
   "emacs/"
   (or (getenv "XDG_STATE_HOME")
       (expand-file-name "~/.local/state/")))
  "Directory for Emacs state files.")

(dolist (dir (list rc/cache-directory rc/data-directory rc/state-directory))
  (make-directory dir t))

;; ----------------------------
;; Native Compilation
;; ----------------------------
(when (featurep 'native-compile)
  ;; Silence compiler warnings
  (setq native-comp-async-report-warnings-errors nil)
  (setq native-comp-warning-on-missing-source nil)
  ;; Optimize native compilation
  (setq native-comp-speed 2))

;; ----------------------------
;; UI Elements (disable early for faster startup)
;; ----------------------------
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Prevent unnecessary UI updates during startup
(setq frame-inhibit-implied-resize t)
(when (boundp 'pgtk-wait-for-event-timeout)
  (setq-default pgtk-wait-for-event-timeout 0))

;; Seed the initial frame with Solarized colors before the theme package loads.
(require 'dbus nil t)

(defconst rc/solarized-dark-frame-colors
  '((background-color . "#002b36")
    (foreground-color . "#839496")
    (cursor-color . "#93a1a1")
    (background-mode . dark))
  "Frame parameters matching Solarized Dark.")

(defconst rc/solarized-light-frame-colors
  '((background-color . "#fdf6e3")
    (foreground-color . "#657b83")
    (cursor-color . "#586e75")
    (background-mode . light))
  "Frame parameters matching Solarized Light.")

(defun rc/early-portal-color-scheme ()
  "Return the current portal color scheme, or nil when unavailable."
  (when (featurep 'dbusbind)
    (condition-case nil
        (let ((value
               (dbus-call-method
                :session
                "org.freedesktop.portal.Desktop"
                "/org/freedesktop/portal/desktop"
                "org.freedesktop.portal.Settings"
                "Read"
                "org.freedesktop.appearance"
                "color-scheme")))
          (cond
           ((equal value '((1))) 'dark)
           ((equal value '((2))) 'light)
           ((equal value '(1)) 'dark)
           ((equal value '(2)) 'light)
           (t nil)))
      (error nil))))

(defun rc/apply-initial-frame-colors ()
  "Apply frame colors that match the later Solarized theme selection."
  (let ((colors (if (eq (rc/early-portal-color-scheme) 'light)
                    rc/solarized-light-frame-colors
                  rc/solarized-dark-frame-colors)))
    (dolist (param colors)
      (add-to-list 'default-frame-alist param))
    (dolist (param colors)
      (add-to-list 'initial-frame-alist param))
    (setq frame-background-mode (cdr (assq 'background-mode colors)))
    (set-face-attribute 'default nil
                        :background (cdr (assq 'background-color colors))
                        :foreground (cdr (assq 'foreground-color colors)))))

(rc/apply-initial-frame-colors)

;; ----------------------------
;; Package Management
;; ----------------------------
(setq package-enable-at-startup nil
      package-user-dir (expand-file-name "elpa/" rc/data-directory))

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" rc/cache-directory)))

;; Use upstream archives for reliability.
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;;; early-init.el ends here
