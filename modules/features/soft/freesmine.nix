{
  flake.nixosModules.freesmine = {pkgs, ...}: {
    inputs.freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
