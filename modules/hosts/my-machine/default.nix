{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.myNixos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.myMachineConfiguration
    ];
  };
}
