+++
title = "Doom Modules"
author = ["Nikita Tchayka"]
date = 2025-04-06T00:00:00+01:00
draft = false
+++

This is the heart of Doom Emacs: the `init.el` file.

Here I declare which Doom modules are enabled, in which order, and with what flags.

All functionality in Doom Emacs derives from modules: you only load what you declare here.

This file is tangled directly into my Doom configuration, at:

```text
.hm/emacs/doom.d/init.el
```

We begin with the standard Doom Emacs declaration:

```emacs-lisp
;;; init.el -*- lexical-binding: t; -*-
```

This ensures proper scoping and byte-compilation.

Now, the core declaration of enabled modules using \`doom!\`:

```emacs-lisp
(doom! :input
       ;;bidi
       ;;chinese
       ;;japanese
       ;;layout

       :completion
       (company +childframe)
       ;;helm
       ;;ido
       ;;ivy
       vertico

       :ui
       ;;deft
       doom
       doom-dashboard
       ;;doom-quit
       ;;(emoji +unicode)
       hl-todo
       ;;hydra
       indent-guides
       ligatures
       ;;minimap
       modeline
       nav-flash
       ;;neotree
       ophints
       (popup +defaults)
       ;;tabs
       treemacs
       ;;unicode
       (vc-gutter +pretty)
       vi-tilde-fringe
       ;;window-select
       workspaces
       ;;zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       ;;god
       ;;lispy
       ;;multiple-cursors
       ;;objed
       ;;parinfer
       ;;rotate-text
       snippets
       word-wrap

       :emacs
       dired
       electric
       ;;ibuffer
       undo
       vc

       :term
       eshell
       ;;shell
       ;;term
       vterm

       :checkers
       (syntax +childframe)
       (spell +flyspell)
       grammar

       :tools
       ;;ansible
       ;;biblio
       ;;collab
       (debugger +lsp)
       ;;direnv
       docker
       ;;editorconfig
       ;;ein
       (eval +overlay)
       ;;gist
       lookup
       lsp
       magit
       ;;make
       ;;pass
       ;;pdf
       ;;prodigy
       ;;rgb
       ;;taskrunner
       ;;terraform
       ;;tmux
       ;;tree-sitter
       ;;upload

       :os
       (:if IS-MAC macos)
       tty

       :lang
       ;;agda
       ;;beancount
       ;;(cc +lsp)
       ;;clojure
       ;;common-lisp
       ;;coq
       ;;crystal
       ;;csharp
       ;;data
       ;;(dart +flutter)
       ;;dhall
       ;;elixir
       ;;elm
       emacs-lisp
       ;;erlang
       ;;ess
       ;;factor
       ;;faust
       ;;fortran
       ;;fsharp
       ;;fstar
       ;;gdscript
       (go +lsp)
       ;;(graphql +lsp)
       (haskell +lsp)
       ;;hy
       ;;idris
       ;;json
       ;;(java +lsp)
       ;;javascript
       ;;julia
       ;;kotlin
       ;;latex
       ;;lean
       ;;ledger
       ;;lua
       markdown
       ;;nim
       nix
       ;;ocaml
       (org +hugo +journal +roam2)
       ;;php
       ;;plantuml
       ;;purescript
       ;;python
       ;;qt
       ;;racket
       ;;raku
       rest
       ;;rst
       ;;(ruby +rails)
       ;;(rust +lsp)
       ;;scala
       ;;(scheme +guile)
       sh
       ;;sml
       ;;solidity
       ;;swift
       ;;terra
       ;;web
       yaml

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;;calendar
       ;;emms
       ;;everywhere
       ;;irc
       ;;(rss +org)
       ;;twitter

       :config
       ;;literate
       (default +bindings +smartparens))
```

This file is declarative, readable, and extensible. It defines **my** Emacs — just the way I want it, no more, no less.

The comments within the original file were instructive for exploration, but in this version, Org Mode takes their place.

Any changes to this document must be followed by an update of the Home Manager environment,
followed by a:

```sh
doom sync
```

so that the module tree is recompiled and updated.
