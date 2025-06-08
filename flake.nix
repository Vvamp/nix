# ╔══════════════════════════════════════════╗
# ║      Vvamp’s NixOS Configuration         ║
# ╚══════════════════════════════════════════╝
{
  description = "Vvamp's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darkmatter-grub-theme = {
      url = gitlab:VandalByte/darkmatter-grub-theme;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, darkmatter-grub-theme, ... }:
    let
      system = "x86_64-linux";
      pkgs   = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ( { lib, ... }: {
                nixpkgs.config = {
                  allowUnfree = true;
                  allowUnfreePredicate = pkg:
                    builtins.elem (lib.getName pkg) [ "masterpdfeditor" ];
                };
            } )
            darkmatter-grub-theme.nixosModule
            ./hosts/default/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs     = true;
              home-manager.useUserPackages   = true;
              home-manager.backupFileExtension = "backup"; 
              home-manager.users.vvamp       = ./home/vvamp.nix;
            }
             {
               environment.systemPackages = with pkgs; [ home-manager ];
             }
          ];

          specialArgs = { inherit home-manager; };
        };
      };
    };
}
