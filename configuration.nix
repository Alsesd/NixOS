{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./system_info/default.nix

    ./utility/stylix.nix
    ./utility/nix.nix

    ./scripts/active.nix

    ./graphics/default.nix
    ./test.nix
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    git
    ventoy-full
    usbutils
    docker
    fuse
    fuse3
  ];

  hardware.cpu.intel.updateMicrocode = true;
  xdg.autostart.enable = true;
  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100; # always preferred over any disk swap
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    enableNotifications = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 0; # let Ananicy handle niceness
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        nv_powermizer_mode = 1; # prefer maximum performance
      };
      cpu = {
        park_cores = "no";
        pin_cores = "no";
      };
    };
  };
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  boot.blacklistedKernelModules = ["psmouse"];

  networking.hostName = "nixos";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05";
}
