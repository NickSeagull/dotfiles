{
  description = "Minimal macOS configuration for corthan";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-darwin, home-manager, ... }: {
    darwinConfigurations.corthan = nix-darwin.lib.darwinSystem {
      modules = [
        ./hosts/corthan/darwin.nix
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
