{
  description = "Home Manager configuration of nick";

  # Usage: home-manager switch --flake .#$(nix eval --impure --raw --expr 'builtins.currentSystem')
  # Or create an alias: alias hms='home-manager switch --flake .#$(nix eval --impure --raw --expr "builtins.currentSystem")'

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, home-manager, flake-utils, ... }:
    let
      systems = flake-utils.lib.defaultSystems;
      forEachSystem = f: nixpkgs.lib.genAttrs systems f;
    in
    {
      homeConfigurations = forEachSystem (system: 
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
        }
      );
    };
}
