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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-generators,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    # --- SHARED VARIABLES BLOCK ---
    vars = {
      username = "alsesd";
      # IMPORTANT: Use a relative path like ./wallpaper.png
      # or an absolute path like /home/alsesd/Pictures/wallpaper.png (NO QUOTES)
      wallpaper = /home/alsesd/Pictures/NixWallBin.png;
    };
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "archiver-*"
          "ventoy-1.1.10"
          "anytype"
          "obsidian"
        ];
      };
    };
    allDevShells = import ./shells.nix {inherit pkgs;};
  in {
    nixosConfigurations.myNixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs system vars;}; # Passing 'vars' here
      modules = [
        {nixpkgs.pkgs = pkgs;}
        ./configuration.nix
        ./system_info/hardware-configuration.nix
        inputs.stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs vars;}; # Passing 'vars' to Home Manager
            users.${vars.username} = import ./home.nix;
          };
        }
      ];
    };

    devShells.${system} =
      allDevShells // {default = allDevShells.python;};
  };
}
