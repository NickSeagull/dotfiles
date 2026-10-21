# Global skill installation

`retro` and its required `writing-for-agents` skill are vendored from
[mattpocock/skills](https://github.com/mattpocock/skills), revision
`5beb35b040e3de97e54fa9e386d7e42d15c295c2`. Their upstream directories are
`skills/engineering/retro` and `skills/productivity/writing-for-agents`.
Each copy retains the upstream MIT license.

Home Manager owns their global directory links through
`config/agent-skills/default.nix`. Keep changes in this repository, then build,
activate and verify the installed links using `activate-darwin`.
Directory links keep the supporting files beside each manifest.

When updating, inspect upstream skill calls and relative references before
replacing both directories from a pinned revision. Preserve this installation
reference and its manifest pointer. Record the new revision here, stage newly
referenced files before building, and verify the global copies match the sources.

`retro` explicitly calls `writing-for-agents`; its supporting
`SKILL-MECHANICS.md` ships in that directory. It has no tracker or domain-doc
setup dependency. The separately installed `setup-matt-pocock-skills` is already
available under `~/.codex/skills`; repo and global instructions retain the user's
Plane tracker and documentation conventions.

Preserve upstream's explicit invocation policy for `retro`. Global availability
does not request automatic retrospectives after every task.
