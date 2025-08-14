;;; init.el --- Emacs configuration loader -*- lexical-binding: t -*-

;;; Commentary:
;; This minimal init.el loads the actual configuration from config.org
;; using org-babel to enable literate programming.

;;; Code:

;; Bootstrap straight.el package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Install org if needed
(straight-use-package 'org)

;; Load the actual configuration from config.org
(org-babel-load-file (expand-file-name "config.org" user-emacs-directory))

;;; init.el ends here