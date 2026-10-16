_: {
  flake.nixosModules.boot = {pkgs, ...}: {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      kernelPackages = pkgs.linuxPackages_latest;

      blacklistedKernelModules = [
        "psmouse"
        "rtsx_pci"
        "i2c_nvidia_gpu"
        "ucsi_ccg"
      ];

      kernelParams = [
        "pcie_aspm=off"
        "intel_pstate=active"
      ];

      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 1024;
      };
    };
  };
}
