;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This picks a Solarized variant from GNOME's color
;; scheme setting.
(require 'subr-x)

(defconst yz/doom-theme-dark 'doom-solarized-dark)
(defconst yz/doom-theme-light 'doom-solarized-light)

(defvar yz/dashboard-image-path nil
  "Path to your custom dashboard image.

If nil, Doom will use the first readable file among:
  assets/startup.png
  assets/startup.jpg
  assets/startup.jpeg
  assets/startup.svg
inside `doom-user-dir'. If none exists, Doom falls back to its default banner.")

(defun yz/find-dashboard-image ()
  "Return the dashboard image to use, or nil to keep Doom's default banner."
  (let ((candidates
         (delq nil
               (list (when yz/dashboard-image-path
                       (expand-file-name yz/dashboard-image-path doom-user-dir))
                     (expand-file-name "assets/startup.png" doom-user-dir)
                     (expand-file-name "assets/startup.jpg" doom-user-dir)
                     (expand-file-name "assets/startup.jpeg" doom-user-dir)
                     (expand-file-name "assets/startup.svg" doom-user-dir)))))
    (catch 'found
      (dolist (file candidates)
        (when (file-readable-p file)
          (throw 'found file))))))

(defun yz/dconf-color-scheme ()
  "Return GNOME's current color scheme as a trimmed string, if available."
  (when (executable-find "dconf")
    (string-trim
     (shell-command-to-string
      "dconf read /org/gnome/desktop/interface/color-scheme 2>/dev/null"))))

(defun yz/current-doom-theme ()
  "Choose the Doom Solarized theme that matches GNOME's preference."
  (pcase (yz/dconf-color-scheme)
    ("'prefer-dark'" yz/doom-theme-dark)
    ((pred stringp) yz/doom-theme-light)
    (_ yz/doom-theme-dark)))

(setq doom-theme (yz/current-doom-theme))

;; Maple Mono NF CN is already installed via the system font package list.
(setq doom-font (font-spec :family "Maple Mono NF CN" :size 14 :weight 'regular)
      doom-big-font (font-spec :family "Maple Mono NF CN" :size 20 :weight 'regular)
      +dashboard-banner-vertical-padding '(1 . 2))

(when-let ((image (yz/find-dashboard-image)))
  (setq fancy-splash-image image))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Note/org/")

;; Native-style scrolling feels better without Evil and pairs well with
;; `smooth-scroll' in Doom.
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(setq scroll-margin 0
      scroll-conservatively 101
      auto-window-vscroll nil
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse t
      fast-but-imprecise-scrolling nil)

(autoload 'vterm-toggle "vterm-toggle" nil t)

(defun yz/toggle-project-tree ()
  "Open or hide the current project's Treemacs sidebar."
  (interactive)
  (+treemacs/toggle))

(defun yz/focus-project-tree ()
  "Jump focus into Treemacs."
  (interactive)
  (require 'treemacs)
  (treemacs-select-window))

(defun yz/add-project-to-tree ()
  "Add a directory into the current Treemacs workspace."
  (interactive)
  (require 'treemacs)
  (call-interactively #'treemacs-add-project-to-workspace))

(defun yz/toggle-vterm ()
  "Toggle the shared vterm popup."
  (interactive)
  (require 'vterm-toggle)
  (call-interactively #'vterm-toggle))

(map! :g "C-c t" #'yz/toggle-project-tree
      :g "C-c o" #'yz/focus-project-tree
      :g "C-c p" #'yz/add-project-to-tree
      :g "C-c v" #'yz/toggle-vterm
      :g "M-o" #'other-window)

(after! ace-window
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(after! treemacs
  (setq treemacs-width 32
        treemacs-width-is-initially-locked nil
        treemacs-text-scale 0)
  (treemacs-filewatch-mode 1)
  (treemacs-follow-mode 1))

(use-package! vterm-toggle
  :after vterm
  :commands (vterm-toggle vterm-toggle-forward vterm-toggle-backward)
  :config
  (define-key vterm-mode-map (kbd "s-n") #'vterm-toggle-forward)
  (define-key vterm-mode-map (kbd "s-p") #'vterm-toggle-backward))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
