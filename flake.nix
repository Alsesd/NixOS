{
  description = "My favourite NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs version
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs version
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # OUTPUTS: What your flake produces
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    # Define system architecture
    system = "x86_64-linux";

    # Import nixpkgs with configuration
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true; # Allow proprietary software (Discord, Steam, etc.)
    };

    # Load the development shells from devshells.nix
    allDevShells = import ./shells.nix {inherit pkgs;};
  in {
    # NIXOS SYSTEM CONFIGURATION
    nixosConfigurations = {
      # "myNixos" is your hostname - change if needed
      myNixos = nixpkgs.lib.nixosSystem {
        # Pass inputs and system to modules
        specialArgs = {inherit inputs system;};

        modules = [
          # System configuration (packages, services, etc.)
          ./configuration.nix

          # Hardware-specific config (filesystems, boot, etc.)
          ./system_info/hardware-configuration.nix

          # Enable Stylix theming module
          inputs.stylix.nixosModules.stylix
          # Enable home-manager as NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              # User configuration (username must match your actual user)
              users.alsesd = import ./home.nix;
            };
          }
        ];
      };
    };

    # DEVELOPMENT SHELLS
    # This defines the set of available shells and explicitly sets 'python' as the default.
    devShells.${system} =
      allDevShells
      // {
        # FIX: Set the 'default' attribute inside devShells.${system}
        default = allDevShells.python;
      };
  };
}
