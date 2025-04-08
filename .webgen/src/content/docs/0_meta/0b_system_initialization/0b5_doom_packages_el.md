+++
title = "Doom Packages"
author = ["Nikita Tchayka"]
date = 2025-04-06T00:00:00+01:00
draft = false
+++

This file lists all the additional packages I install manually on top of Doom Emacs' module system.

It is tangled into:

```text
.hm/emacs/doom.d/packages.el
```

To apply any changes made here, I run:

```sh
doom sync
```

and restart Emacs, or call `doom/reload` interactively.

---

We begin with the standard Emacs header for Doom packages:

```emacs-lisp
;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el
```

Now, we list the packages I explicitly include in this setup:

---

The Catppuccin theme, which I use throughout my Emacs setup for its soothing, readable aesthetic:

```emacs-lisp
(package! catppuccin-theme)
```

GitHub Copilot integration for Emacs, installed from its source repo:

```emacs-lisp
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))
```

`aidermacs` is my integration with Aider (GPT-assisted workflows). It's a custom tool to assist in architectural decisions and code exploration.

```emacs-lisp
(package! aidermacs)
```

`clipetty` enables clipboard integration over terminal connections, which is especially useful when using Emacs over SSH.

```emacs-lisp
(package! clipetty)
```
