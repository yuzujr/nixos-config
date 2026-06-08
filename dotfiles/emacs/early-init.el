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

;; Detect color scheme
(require 'dbus nil t)

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

(defvar rc/initial-color-scheme
  (or (rc/early-portal-color-scheme) 'dark)
  "Desktop color scheme captured once during startup.")

;; ----------------------------
;; Package Activation
;; ----------------------------
(setq package-enable-at-startup nil
      package-user-dir (expand-file-name "elpa/" rc/data-directory)
      package-gnupghome-dir (expand-file-name "package-gnupg/" rc/state-directory)
      package-quickstart-file (expand-file-name "package-quickstart.el" rc/cache-directory))

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" rc/cache-directory)))

;;; early-init.el ends here
