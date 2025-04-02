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
(setq doom-font (font-spec :family "Maple Mono" :size 20 :spacing 90))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/nickseagull.dev/")
(setq user-full-name "Nikita Tchayka")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
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
          ;; Only kill buffer if it's not the one you're actively editing
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
         (hugo-root-dir (expand-file-name "website/src/" org-root-dir)))
    (ns/tangle-org-files-in-dir org-root-dir)
    (ns/hugo-export-org-files-in-dir org-root-dir hugo-root-dir)))

(defun ns/auto-tangle-and-export-on-save ()
  "Auto tangle and export if the saved Org file is under `org-directory`."
  (when (and (eq major-mode 'org-mode)
             (string-prefix-p (expand-file-name org-directory)
                              (buffer-file-name)))
    (run-with-idle-timer 0.5 nil #'ns/tangle-and-export-all-org-files)))

(add-hook 'after-save-hook #'ns/auto-tangle-and-export-on-save)

;; accept completion from copilot and fallback to company
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
  ;; See the Configuration section below
  (aidermacs-use-architect-mode t)
  (aidermacs-default-model "gpt-4o"))

;; Add dap-hydra to go mode on SPC m D
(add-hook! go-mode
  (map! :localleader
        :map go-mode-map
        "D" #'dap-hydra))


(setq dap-auto-configure-features '(sessions locals controls tooltip))
