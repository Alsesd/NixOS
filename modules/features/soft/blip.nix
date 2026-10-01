{inputs, ...}: {
  flake.nixosModules.blip = _: {
    imports = [
      inputs.blip.nixosModules.default
    ];

    programs.blip.enable = true;
  };
}
