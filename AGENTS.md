This is a dotfiles repo that manages configuration of a macbook via nix-darwin and home manager. Assume that any request is geared towards this repo files, unless stated otherwise.

After each completed task, ensure that you either maintain the agent skills in this codebase with the user preferences and learnings.

Keep research documents under `.agents-state/docs/`, not the repository's top-level `docs/` folder. `.agents-state/` is local agent state and must remain ignored by Git.

This is a public GitHub repository. Before every commit and push, inspect all changes being published, including unrelated changes, for tokens, passwords, API keys, private keys, credential files, token caches, private repository URLs, and other private or sensitive information. Keep credentials and authentication caches outside the repository and Nix store; publish only configuration that refers to them safely. If sensitive information is found, exclude it from publication, report its location without exposing its value, and resolve it before pushing.

If the task is ambiguous or you require knowing user's preferences, grill the user.

Default to managing everything through nix, even external configuration files, those should be linked by home-manager.

this config IS THE SOURCE OF TRUTH, so enable everything that ensures that home-manager overwrites files and so on.

Do not suggest that the user review plans, skills, documents, code, or other artifacts. Perform the necessary reviews and checks yourself. When the task is complete, report the result without inventing a next action for the user.

After configuration changes, automatically build and activate the nix-darwin/Home Manager configuration so the change is picked up. Use `skills/activate-darwin/SKILL.md` for the native macOS authorization dialog, reload affected apps when safe, and verify the running settings. Building without activation is not completion. Do not ask for activation permission again; this is standing authorization. Respect a cancelled authorization dialog and preserve unsaved work.

When installing an app or changing its theme, use `skills/configure-app-theme/SKILL.md` to apply Cyberdream dark with scarlet accents wherever supported. Theme configuration is part of installation; an explicit theme choice in the current request takes precedence.

commit and push everything (icluding the unrelated changes in the branch) once a task is finished. When the task is finished and merge to main directly, no need to make PRs

