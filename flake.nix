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

    outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
        ./hosts/default/configuration.nix
        home-manager.nixosModules.home-manager
        ];
        specialArgs = {
        inherit home-manager;
        };
    };
    };

}
