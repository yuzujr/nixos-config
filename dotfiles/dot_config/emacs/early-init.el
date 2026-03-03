;;; early-init.el -*- lexical-binding: t; -*-

;; ----------------------------
;; Performance: Startup GC threshold
;; ----------------------------
;; Defer garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

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

;; ----------------------------
;; Package Management
;; ----------------------------
(setq package-enable-at-startup nil)

;; Use upstream archives for reliability.
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;;; early-init.el ends here
