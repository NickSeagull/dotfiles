{
  description = "REPLICANT";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      homeConfigurations = {
        nick =
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./modules/doom-emacs/default.nix
              ./home.nix
            ];
          };
      };
    };
}
