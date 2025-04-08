;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Maple Mono" :size 20 :spacing 90))

(let ((eink (getenv "EINK_MODE")))
  (if (string= eink "1")
      (setq doom-theme 'doom-one-light)
    (setq doom-theme 'catppuccin)))

(setq display-line-numbers-type 'relative)

(setq org-directory "~/nickseagull.dev/")
(setq user-full-name "Nikita Tchayka")

(defun ns/org-file-has-tangle-blocks-p (file)
  "Return non-nil if FILE contains any Babel src block with a :tangle path or yes."
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (re-search-forward "#\\+BEGIN_SRC.*:tangle\\s-+\\([^ \t\n]+\\)" nil t)))

(defun ns/org-babel-auto-tangle ()
  "Auto-tangle current Org file on save if it contains any tangleable blocks."
  (when (and (buffer-file-name)
             (string= (file-name-extension (buffer-file-name)) "org")
             (ns/org-file-has-tangle-blocks-p (buffer-file-name)))
    (org-babel-tangle)))

(after! org-mode
  (add-hook! org-mode
    (lambda ()
      (add-hook! after-save-hook #'ns/org-babel-auto-tangle nil t))))

(defun ns/tangle-org-files-in-dir (directory)
  "Recursively tangle Org files in DIRECTORY that contain Babel blocks with
:tangle."
  (interactive "DDirectory: ")
  (let ((org-files (directory-files-recursively directory "\\.org$")))
    (dolist (file org-files)
      (when (ns/org-file-has-tangle-blocks-p file)
        (with-current-buffer (find-file-noselect file)
          (org-babel-tangle))))))

(defun ns/hugo-export-org-files-in-dir (org-root-dir hugo-root-dir)
  "Recursively export Org files under ORG-ROOT-DIR using ox-hugo.
Place the resulting .md files in HUGO-ROOT-DIR/content/docs/,
preserving the same subdirectory structure.

Skips killing the current buffer if it's one of the exported files."
  (interactive "DOrg root directory: \nDHugo root directory: ")
  (require 'ox-hugo)
  (let ((org-files (directory-files-recursively org-root-dir "\\.org$"))
        (content-root (expand-file-name "content/docs/" hugo-root-dir))
        (current (current-buffer)))
    (dolist (org-file org-files)
      (let* ((relative-path (file-relative-name org-file org-root-dir))
             (md-filename (concat (file-name-sans-extension relative-path) ".md"))
             (final-md-path (expand-file-name md-filename content-root))
             (target-dir (file-name-directory final-md-path)))
        (make-directory target-dir t)
        (with-current-buffer (find-file-noselect org-file)
          (setq-local org-hugo-base-dir hugo-root-dir)
          (org-hugo-export-wim-to-md)
          (unless (eq (current-buffer) current)
            (kill-buffer))))))
  (message "Finished exporting Org files from %s to %s/content/docs"
           (abbreviate-file-name org-root-dir)
           (abbreviate-file-name hugo-root-dir)))

(defun ns/tangle-and-export-all-org-files ()
  "Tangle and export all Org files in `org-directory` to Hugo markdown.
Hugo project is assumed to be at `org-directory/website/src/`."
  (interactive)
  (let* ((org-root-dir (expand-file-name org-directory))
         (hugo-root-dir (expand-file-name ".webgen/src/" org-root-dir)))
    (ns/tangle-org-files-in-dir org-root-dir)
    (ns/hugo-export-org-files-in-dir org-root-dir hugo-root-dir)))

(defun ns/auto-tangle-and-export-on-save ()
  "Auto tangle and export if the saved Org file is under `org-directory`."
  (when (and (eq major-mode 'org-mode)
             (string-prefix-p (expand-file-name org-directory)
                              (buffer-file-name)))
    (run-with-idle-timer 0.5 nil #'ns/tangle-and-export-all-org-files)))

(add-hook 'after-save-hook #'ns/auto-tangle-and-export-on-save)

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(after! treemacs
  (setq treemacs-position 'right))

(use-package! aidermacs
  :bind
  (("C-c a" . aidermacs-transient-menu))
  :custom
  (aidermacs-use-architect-mode t)
  (aidermacs-default-model "gpt-4o"))

(setq copilot-max-char -1)

(add-hook! go-mode
  (map! :localleader
        :map go-mode-map
        "D" #'dap-hydra))

(setq dap-auto-configure-features '(sessions locals controls tooltip))

(use-package! clipetty
  :hook (after-init . global-clipetty-mode))
