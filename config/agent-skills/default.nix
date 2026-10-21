{ lib, ... }:
let
  skills = [ "retro" "writing-for-agents" ];
  # Codex and Orca discover ~/.agents/skills; Claude Code uses ~/.claude/skills.
  roots = [ ".agents/skills" ".claude/skills" ];
in
{
  home.file = lib.listToAttrs (lib.concatMap (root:
    map (name: {
      name = "${root}/${name}";
      value = {
        source = ../../skills + "/${name}";
        force = true;
      };
    }) skills
  ) roots);
}
