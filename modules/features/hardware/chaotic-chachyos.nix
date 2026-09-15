{inputs, ...}: {
  flake.nixosModules.chaoticCachyos = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [
      inputs.chaotic.nixosModules.default
    ];

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
    hardware.nvidia.package = lib.mkForce pkgs.nvidia_cachyos;

    services.scx.enable = true;

    specialisation.stable-kernel.configuration = {
      # mkOverride 10: stronger than mkForce (50), needed because
      # specialisations re-inherit this same module's mkForce cachyos
      # lines, so a plain mkForce here would collide with them.
      boot.kernelPackages = lib.mkOverride 10 pkgs.linuxPackages_xanmod_latest;
      hardware.nvidia.package = lib.mkOverride 10 config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
