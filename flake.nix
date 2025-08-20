{
  description = "My favourite NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    # Optional: Add nvf for better Neovim (we can add this later)
    # nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-colors,
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
        specialArgs = {inherit inputs nix-colors system;};

        modules = [
          ./configuration.nix
          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alsesd = import ./home.nix;
            home-manager.backupFileExtension = "backup";

            # Pass inputs to home-manager
            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
      };
    };
  };
}
