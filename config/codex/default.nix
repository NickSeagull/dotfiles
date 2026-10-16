{ config, lib, pkgs, ... }:
let
  codexHome = "${config.home.homeDirectory}/.codex";
  alternateHome = "${config.home.homeDirectory}/.codex-h";
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
  # Shell-independent shortcuts, available through the existing ~/.local/bin PATH.
  home.file = {
    ".local/bin/cx" = {
      source = pkgs.writeShellScript "cx" ''
        exec codex --approve-for-me "$@"
      '';
      force = true;
    };
    ".local/bin/cxh" = {
      source = pkgs.writeShellScript "cxh" ''
        export CODEX_HOME=${lib.escapeShellArg alternateHome}
        exec codex --approve-for-me -c 'cli_auth_credentials_store="file"' "$@"
      '';
      force = true;
    };
    ".codex/themes/${themeName}.tmTheme" = {
      source = theme;
      force = true;
    };
  } // lib.genAttrs
    # Share preferences and resources; keep auth.json and sessions separate.
    (map (name: ".codex-h/${name}") [ "config.toml" "skills" "themes" ])
    (path: {
      source = config.lib.file.mkOutOfStoreSymlink "${codexHome}/${baseNameOf path}";
      force = true;
    });

  # Codex also writes trust, plugin, and onboarding state to config.toml.
  # Reapply the owned theme setting while preserving that mutable state.
  home.activation.codexTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${python}/bin/python3 ${./set-theme.py} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/.codex/config.toml"} \
      ${lib.escapeShellArg themeName}
  '';
}
