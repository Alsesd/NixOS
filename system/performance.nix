{pkgs, ...}: {
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
}
