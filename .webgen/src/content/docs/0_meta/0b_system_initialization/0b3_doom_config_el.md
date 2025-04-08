+++
title = "Doom Emacs Config"
author = ["Nikita Tchayka"]
date = 2025-04-06T00:00:00+01:00
draft = false
+++

This is my personal `config.el` for Doom Emacs. It controls font settings, theme, Org-mode behavior, tangling and exporting, Copilot and AI tooling, and various Doom-specific enhancements.

We set lexical binding for the file.

```emacs-lisp
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
```

We begin by setting the primary font for Doom. I'm using `Maple Mono` at size 20, with increased spacing to give it a clean and open feel.

```emacs-lisp
(setq doom-font (font-spec :family "Maple Mono" :size 20 :spacing 90))
```

The theme I use is `catppuccin` — soft, readable, and comfortable on the eyes.

```emacs-lisp
(let ((eink (getenv "EINK_MODE")))
  (if (string= eink "1")
      (setq doom-theme 'doom-one-light)
    (setq doom-theme 'catppuccin)))
```

I enable relative line numbers across the board, which helps with navigation.

```emacs-lisp
(setq display-line-numbers-type 'relative)
```

My Org files live in the root of my repository — this ensures that tangling and exporting behave predictably from anywhere.

```emacs-lisp
(setq org-directory "~/nickseagull.dev/")
(setq user-full-name "Nikita Tchayka")
```

Now we define a helper that determines whether an Org file contains any tangleable code blocks.

```emacs-lisp
(defun ns/org-file-has-tangle-blocks-p (file)
  "Return non-nil if FILE contains any Babel src block with a :tangle path or yes."
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (re-search-forward "#\\+BEGIN_SRC.*:tangle\\s-+\\([^ \t\n]+\\)" nil t)))
```

We now define a function that automatically tangles an Org file when it is saved, but only if it includes tangleable blocks.

```emacs-lisp
(defun ns/org-babel-auto-tangle ()
  "Auto-tangle current Org file on save if it contains any tangleable blocks."
  (when (and (buffer-file-name)
             (string= (file-name-extension (buffer-file-name)) "org")
             (ns/org-file-has-tangle-blocks-p (buffer-file-name)))
    (org-babel-tangle)))
```

This behavior is attached to `org-mode` buffers only.

```emacs-lisp
(after! org-mode
  (add-hook! org-mode
    (lambda ()
      (add-hook! after-save-hook #'ns/org-babel-auto-tangle nil t))))
```

Now we define a recursive tangler for all Org files in a directory.

```emacs-lisp
(defun ns/tangle-org-files-in-dir (directory)
  "Recursively tangle Org files in DIRECTORY that contain Babel blocks with
:tangle."
  (interactive "DDirectory: ")
  (let ((org-files (directory-files-recursively directory "\\.org$")))
    (dolist (file org-files)
      (when (ns/org-file-has-tangle-blocks-p file)
        (with-current-buffer (find-file-noselect file)
          (org-babel-tangle))))))
```

To complement tangling, we now define a function that exports all Org files under a directory to Hugo-compatible Markdown files, preserving their relative structure.

```emacs-lisp
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
```

This next function ties it all together: tangle, then export everything. This is the one I call when building the site.

```emacs-lisp
(defun ns/tangle-and-export-all-org-files ()
  "Tangle and export all Org files in `org-directory` to Hugo markdown.
Hugo project is assumed to be at `org-directory/website/src/`."
  (interactive)
  (let* ((org-root-dir (expand-file-name org-directory))
         (hugo-root-dir (expand-file-name ".webgen/src/" org-root-dir)))
    (ns/tangle-org-files-in-dir org-root-dir)
    (ns/hugo-export-org-files-in-dir org-root-dir hugo-root-dir)))
```

We also hook this function to saving files, but only if they belong to the Org source tree.

```emacs-lisp
(defun ns/auto-tangle-and-export-on-save ()
  "Auto tangle and export if the saved Org file is under `org-directory`."
  (when (and (eq major-mode 'org-mode)
             (string-prefix-p (expand-file-name org-directory)
                              (buffer-file-name)))
    (run-with-idle-timer 0.5 nil #'ns/tangle-and-export-all-org-files)))

(add-hook 'after-save-hook #'ns/auto-tangle-and-export-on-save)
```

I use GitHub Copilot for completions, and fall back to Company if needed.

```emacs-lisp
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
```

I also reposition Treemacs to the right of the screen.

```emacs-lisp
(after! treemacs
  (setq treemacs-position 'right))
```

The `aidermacs` package gives me AI-driven tools and workflows. I bind its main menu to `C-c a`.

```emacs-lisp
(use-package! aidermacs
  :bind
  (("C-c a" . aidermacs-transient-menu))
  :custom
  (aidermacs-use-architect-mode t)
  (aidermacs-default-model "gpt-4o"))
```

I keep using GitHub copilot, but sometimes it gives me warnings about the fact that the source files I edit are too large.
(I know, don't ask). So I just remove the limit here:

```emacs-lisp
(setq copilot-max-char -1)
```

For Go development, I bind the DAP (debugging) hydra to `SPC m D`.

```emacs-lisp
(add-hook! go-mode
  (map! :localleader
        :map go-mode-map
        "D" #'dap-hydra))
```

Lastly, I enable `clipetty` so that Emacs can use the system clipboard over SSH.

```emacs-lisp
(setq dap-auto-configure-features '(sessions locals controls tooltip))

(use-package! clipetty
  :hook (after-init . global-clipetty-mode))
```
