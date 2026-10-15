{ config, lib, pkgs, ... }:
let
  themeName = "cyberdream-scarlet";
  cyberdream = pkgs.fetchzip {
    url = "https://github.com/scottmckendry/cyberdream.nvim/archive/642c55ad2225f9f4809905918121b2c6d252ad58.tar.gz";
    hash = "sha256-V72/C7YicMyMmbI6E3eZ0zTsrlP5i7BpthjCh42G7rU=";
  };
  theme = pkgs.runCommand "${themeName}.tmTheme" { } ''
    substitute ${cyberdream}/extras/textmate/cyberdream.tmTheme "$out" \
      --replace-fail '<string>Cyberdream</string>' '<string>Cyberdream Scarlet</string>' \
      --replace-fail '#ff6e5e' '#ff493d'
  '';
  python = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);
in
{
  home.file.".codex/themes/${themeName}.tmTheme" = {
    source = theme;
    force = true;
  };

  # Codex also writes trust, plugin, and onboarding state to config.toml.
  # Reapply the owned theme setting while preserving that mutable state.
  home.activation.codexTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${python}/bin/python3 ${./set-theme.py} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/config.toml"} \
      ${lib.escapeShellArg themeName}
  '';
}
