{
  description = "Sampaiol's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/0xc000022070/zen-browser-flake
    zen-browser.url = "github:0xc000022070/zen-browser-flake/beta";

    nix-flatpak.url = "github:gmodena/nix-flatpak/latest"; 
  };

  outputs = {
    self, 
    nixpkgs,
    home-manager,
    nix-flatpak,
    ... 
  }@inputs: {
    nixosConfigurations = {
      workstation = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/workstation/configuration.nix
          home-manager.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
        ];
        specialArgs = let
          system = "x86_64-linux";
        in {
          inherit inputs;
          pkgs = import nixpkgs {
            inherit system;
          };
        };
      };
    };
  };
}