{ config, lib, ... }:
let
  wallpaperPath = "${config.home.homeDirectory}/Pictures/Wallpapers/cinder-horizon.png";
in
{
  home.file."Pictures/Wallpapers/cinder-horizon.png" = {
    source = ../assets/wallpapers/cyberdream-scarlet/cinder-horizon.png;
    force = true;
  };

  programs.desktoppr = {
    enable = true;
    settings = {
      picture = wallpaperPath;
      scale = "fill";
      color = "16181A";
      setOnlyOnce = false;
    };
  };

  # The program module already waits for setDarwinDefaults; also wait for the image.
  home.activation.wallpaperLinkReady =
    lib.hm.dag.entryBetween [ "desktoppr" ] [ "linkGeneration" ] "";

  launchd.agents.wallpaper = {
    enable = true;
    config = {
      ProgramArguments = [
        (lib.getExe config.programs.desktoppr.package)
        "manage"
      ];
      RunAtLoad = true;
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Background";
    };
  };
}
