{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Indexing / search dependencies
    fd
    (ripgrep.override { withPCRE2 = true; })

    # Font / icon config
    emacs-all-the-icons-fonts
    nerd-fonts.symbols-only
    maple-mono
    fontconfig

    aider-chat # aidermacs

    nixfmt-classic # :lang nix
    ispell # spellcheck
    shellcheck # for checking bash files
    sqlite # org-roam
    hugo

    nodejs # debugger
    lldb # debugger
    gdb # debugger
    unzip # debugger
    delve # debugger (go)

  ];

  fonts.fontconfig.enable = true;

  # Note that session variables and path can be a bit wonky to get going. To be
  # on the safe side, logging out and in again usually works.
  # Otherwise, to fast-track changes, run:
  # . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
  home.sessionVariables = {
    DOOMDIR = "${config.xdg.configHome}/doom";
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
  };
  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [ realgud-lldb vterm ];
  };

  xdg.configFile."emacs".source = builtins.fetchGit {
    url = "https://github.com/doomemacs/doomemacs.git";
    rev = "b1e6dec47a2d0fa5fd8f7ab55b5f1012d16cb48b";
  };
  xdg.configFile."doom".source = ./doom.d; # Note! This must match $DOOMDIR
}
