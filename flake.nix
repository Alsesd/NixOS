{
  description = "My favourite NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sddm-sugar-candy-nix = {
      url = "github:Zhaith-Izaliel/sddm-sugar-candy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sddm-sugar-candy-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      myNixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};
        modules = [
          ./configuration.nix
          ./system_info/hardware-configuration.nix
          inputs.stylix.nixosModules.stylix
          sddm-sugar-candy-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alsesd = import ./home.nix {inherit pkgs inputs;};
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
      };

      nixpkgs = {
        overlays = [
          sddm-sugar-candy-nix.overlays.default
        ];
      };
    };
  };
}
