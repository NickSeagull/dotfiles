{
  home.username = "nick";
  home.homeDirectory = "/Users/nick";
  home.stateVersion = "26.05";

  # Add user packages (including packaged apps) and dotfiles here when needed.
  home.packages = [ ];
  home.file = { };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Nick Seagull";
      email = "github@nickseagull.dev";
    };
  };
}
