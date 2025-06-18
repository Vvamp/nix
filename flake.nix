# ╔══════════════════════════════════════════╗
# ║      Vvamp’s NixOS Configuration         ║
# ╚══════════════════════════════════════════╝
{
  description = "Vvamp's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    firefox.url = "github:nix-community/flake-firefox-nightly";
    firefox.inputs.nixpkgs.follows = "nixpkgs";
    darkmatter-grub-theme = {
      url = "gitlab:VandalByte/darkmatter-grub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      darkmatter-grub-theme,
      firefox,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;

          modules = [
            (
              { lib, ... }:
              {
                nixpkgs.config = {
                  allowUnfree = true;
                  allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "masterpdfeditor" ];
                };
              }
            )
            darkmatter-grub-theme.nixosModule
            ./hosts/default/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.vvamp = ./home/vvamp.nix;
            }
            {
              environment.systemPackages = with pkgs; [
                home-manager
                inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin

              ];
            }
          ];

        };
      };
    };
}
