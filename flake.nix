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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
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
          inputs.stylix.nixosModules.stylix
          # Импортируем модуль NixOS для niri
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Импортируем home.nix как конфигурацию для пользователя alsesd
            home-manager.users.alsesd = import ./home.nix {inherit pkgs inputs;};
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
      };
    };
  };
}
