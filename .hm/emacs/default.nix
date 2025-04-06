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

    # AI tooling
    aider-chat # aidermacs

    # Languages
    nixfmt-classic
    ispell
    shellcheck
    sqlite
    hugo

    # Debugging stack
    nodejs
    lldb
    gdb
    unzip
    delve

    # LSP / CoPilot
    copilot-language-server
  ];

  fonts.fontconfig.enable = true;

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
  xdg.configFile."doom".source = ./doom.d;
}
