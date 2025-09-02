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
    DOOMDIR = "${config.xdg.configHome}/doom";
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.dataHome}/doom/profiles.30.el";
  };
  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  services = {
    emacs = {
      enable = true;
      startWithUserSession = true;
      # Make emacsclient the default editor
      defaultEditor = true;
    
      # Client configuration
      client = {
        enable = true;  # Enable desktop file for client
      };
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
  # We need to use a writable copy of Doom Emacs, not the Nix store version
  home.activation.cloneDoomEmacs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "$HOME/.config/emacs" ]; then
      run ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs.git "$HOME/.config/emacs"
    fi
  '';

}
