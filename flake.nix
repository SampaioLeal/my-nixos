{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    distro-grub-themes = {
      url = "github:AdisonCavani/distro-grub-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    serpantinum = {
      url = "github:ilyamiro/serpantinum";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tui-center = {
      url = "git+file:///home/sampaiol/Documents/tui-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      ...
    }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # TODO: remove this once the issue is fixed upstream
          permittedInsecurePackages = [
            "beekeeper-studio-6.1.4"
          ];
        };
      };
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations.workstation = lib.nixosSystem {
        system = system;
        specialArgs = { inherit inputs; };
        modules = [
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
            }
          )
          ./configuration.nix
          inputs.distro-grub-themes.nixosModules.${system}.default
          inputs.home-manager.nixosModules.home-manager
          ./hardware-configuration.nix
          ./system
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      homeConfigurations = {
        sampaiol = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home ];
        };
      };
    };
}
