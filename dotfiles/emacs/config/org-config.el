;;; org-config.el -*- lexical-binding: t; -*-

(defconst rc/org-babel-languages
  '((shell . t)
    (python . t)
    ;; Loading `ob-C' through `C' also enables C++ source blocks.
    (C . t))
  "Languages enabled for Org Babel.")

(use-package org
  :ensure nil
  :custom
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0)
  (org-confirm-babel-evaluate nil)
  (org-babel-python-command "python3")
  (org-babel-C-compiler "gcc")
  (org-babel-C++-compiler "g++")
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   rc/org-babel-languages)
  (setq org-babel-default-header-args:python
        '((:results . "output"))))

(provide 'org-config)

;;; org-config.el ends here
