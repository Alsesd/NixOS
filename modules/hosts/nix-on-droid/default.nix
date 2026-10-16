{
  self,
  inputs,
  ...
}: {
  flake.nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "aarch64-linux";
      overlays = [
        inputs.nix-on-droid.overlays.default
      ];
      config.allowUnfree = true;
    };
    modules = [
      ./configuration.nix
    ];
    extraSpecialArgs = {
      inherit self inputs;
    };
    home-manager-path = inputs.home-manager.outPath;
  };
}
