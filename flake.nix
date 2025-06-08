{
  description = "Vvamp's NixOS Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "masterpdfeditor"
          ];
        };
      };
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/default/configuration.nix
          home-manager.nixosModules.home-manager
        ];
        specialArgs = {
          inherit pkgs home-manager;
        };
      };
    };
}
