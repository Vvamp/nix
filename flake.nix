{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          # insert this first to allow unfree packages
          modules = [
            ( { lib, ... }: {
                nixpkgs.config = {
                  allowUnfree = true;
                  allowUnfreePredicate = pkg:
                    builtins.elem (lib.getName pkg) [ "masterpdfeditor" ];
                };
            } )

            # then your normal modules
            ./hosts/default/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs     = true;
              home-manager.useUserPackages   = true;
              home-manager.backupFileExtension = "backup"; 
              home-manager.users.vvamp       = ./home/vvamp.nix;
            }
          ];

          specialArgs = { inherit home-manager; };
        };
      };
    };
}
