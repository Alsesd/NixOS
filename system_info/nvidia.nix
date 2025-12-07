# ============================================================================
# System Fixes - Enhanced for Gaming + USB-C DisplayPort
# ============================================================================
{
  config,
  pkgs,
  ...
}: {
  # ========== AUDIO + RTKIT ==========
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;

  # ========== FIRMWARE ==========
  hardware.firmware = [pkgs.linux-firmware];

  # ========== THUNDERBOLT/USB4 SUPPORT ==========
  # CRITICAL for USB-C DisplayPort Alt Mode
  services.hardware.bolt.enable = true;

  # Allow user access to Thunderbolt devices
  services.udev.extraRules = ''
    # Thunderbolt
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"
  '';

  # ========== KERNEL BLACKLIST ==========
  boot.blacklistedKernelModules = [
    "psmouse" # Old touchpad driver (conflicts with libinput)
    # REMOVED: "ucsi_ccg" - THIS WAS BREAKING USB-C DP!
  ];

  # ========== MODULE OPTIONS ==========
  boot.extraModprobeConfig = ''
    # ===== Intel Wi-Fi =====
    options iwlwifi power_save=0 11n_disable=0 bt_coex_active=0
    options iwlmvm power_scheme=1

    # ===== NVIDIA for Gaming =====
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
    options nvidia NVreg_TemporaryFilePath=/var/tmp

    # ===== USB-C DisplayPort =====
    # Reduce ucsi_ccg timeout to prevent boot delays
    options ucsi_ccg ucsi_ccg_timeout=5000

    # Force load USB-C controller modules
    options typec typec_mode=0
  '';

  # ========== KERNEL MODULES ==========
  # Explicitly load USB-C/Thunderbolt modules
  boot.kernelModules = [
    "thunderbolt"
    "typec"
    "typec_ucsi"
    "ucsi_ccg" # Re-enabled!
    "ucsi_acpi"
  ];

  # ========== LIBINPUT (TOUCHPAD) ==========
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

  # ========== NETWORK MANAGER ==========
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };

  # ========== GAMING OPTIMIZATIONS ==========
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # ========== KERNEL PARAMETERS ==========
  boot.kernelParams = [
    # NVIDIA
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"

    # PCIe optimizations
    "pcie_aspm=off"

    # Performance
    "mitigations=off"
    "split_lock_detect=off"

    # Memory management
    "transparent_hugepage=always"

    # USB-C/Thunderbolt
    "thunderbolt.dyndbg=+p" # Enable debug logging if issues persist
  ];

  # ========== OPENGL/VULKAN 32-BIT SUPPORT ==========
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ========== SYSTEM LIMITS ==========
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "unlimited";
    }
  ];

  # ========== ENVIRONMENT VARIABLES ==========
  environment.sessionVariables = {
    # Uncomment for debugging
    # LIBGL_DEBUG = "verbose";
  };
}
