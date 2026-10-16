{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self inputs;
    };
    modules = [
      self.nixosModules.myMachineConfiguration
    ];
  };
}
