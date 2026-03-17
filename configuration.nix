{pkgs, ...}: {
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
    nix-output-monitor
		wayvnc
  ];
  hardware.cpu.intel.updateMicrocode = true;
  xdg.autostart.enable = true;
  security.polkit.enable = true;
	
programs.mosh.enable = true;
networking.firewall.allowedUDPPortRanges = [{ from = 60000; to = 61000; }];

	networking.firewall.allowedTCPPorts= [5900];

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
    # Reduce scheduler latency
    "kernel.sched_min_granularity_ns" = 500000;
    "kernel.sched_wakeup_granularity_ns" = 1000000;
    # Faster GPU memory reclaim
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 5;
    enableNotifications = true;
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
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
      };
      cpu = {
        park_cores = "no";
        pin_cores = "no";
      };
    };
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event*", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5007", ENV{LIBINPUT_ACCEL_PROFILE}="flat"
  '';

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  boot.blacklistedKernelModules = ["psmouse"];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05";
}
