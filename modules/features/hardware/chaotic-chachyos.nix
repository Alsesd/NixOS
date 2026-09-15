{
  flake.nixosModules.chaoticCachyos = {
    config,
    pkgs,
    lib,
    inputs,
    ...
  }: {
    imports = [
      inputs.chaotic.nixosModules.default
    ];

    # mkForce: overrides the plain `boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;`
    # in configuration.nix, and the plain `hardware.nvidia.package = ...` in nvidia.nix,
    # without a conflicting-definition eval error.
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
    hardware.nvidia.package = lib.mkForce pkgs.nvidia_cachyos;

    services.scx.enable = true; # sched-ext, defaults to scx_rustland

    # Bootloader entry with your normal xanmod kernel + stable NVIDIA driver,
    # so a bad CachyOS build never leaves you without a bootable system —
    # just pick "stable-kernel" at the systemd-boot menu.
    specialisation.stable-kernel.configuration = {
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;
      hardware.nvidia.package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
