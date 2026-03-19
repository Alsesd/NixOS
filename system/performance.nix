{pkgs, ...}: {
  # =========================================================================
  # Performance-specific settings
  # Note: Most settings moved to system/fixes.nix to consolidate fixes
  # =========================================================================

  # Input device acceleration fix (keep here as it's performance-related)
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="event*", ATTRS{idVendor}=="3151", ATTRS{idProduct}=="5007", ENV{LIBINPUT_ACCEL_PROFILE}="flat"
  '';

  # Scheduler settings - commented out due to XanMod kernel compatibility issues
  # These settings were causing "No such file or directory" errors in journal
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    # Reduce scheduler latency - COMMENTED OUT: XanMod may not expose these
    # "kernel.sched_min_granularity_ns" = 500000;
    # "kernel.sched_wakeup_granularity_ns" = 1000000;
    # Faster GPU memory reclaim
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };
}
