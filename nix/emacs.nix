{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nixfmt-rfc-style
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "emacsclient -c";
  };

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
}
