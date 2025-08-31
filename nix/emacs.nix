{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    # Indexing / search dependencies
    fd
    (ripgrep.override { withPCRE2 = true; })

    # Font / icon config
    # Added FiraCode as an example, it's not used in the config example.
    emacs-all-the-icons-fonts
    fontconfig
    nerd-fonts.jetbrains-mono

    nixfmt-rfc-style # :lang nix
  ];

  # Required to autoload fonts from packages installed via Home Manager
  fonts = {
    fontconfig.enable = true;
  };

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "emacsclient -c";
    DOOMDIR = "${config.xdg.configHome}/doom";
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
  };
  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  services = {
    emacs = {
      enable = true;
      startWithUserSession = true;
    };
  };

  programs = {
    emacs = {
      enable = true;
    };
  };

  # Note! This must match $DOOMDIR
  xdg.configFile."doom".source = ../doom;

  # Note! This must match $EMACSDIR
  xdg.configFile."emacs".source = builtins.fetchGit {
    url = "https://github.com/doomemacs/doomemacs.git";
    rev = "1dae2bf916ea631ab0d129218cf69ece94a11e4f";
  };

}
