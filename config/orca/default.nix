{ config, lib, pkgs, ... }:
let
  preferences = ./theme.json;
in
{
  home.file.".config/orca/theme.json" = {
    source = preferences;
    force = true;
  };

  # Orca owns mutable profile/session state; reconcile only appearance keys.
  home.activation.orcaTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run ${pkgs.python3}/bin/python3 ${./set-theme.py} \
      ${lib.escapeShellArg "${config.home.homeDirectory}/Library/Application Support/orca"} \
      ${preferences}
  '';
}
