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
    # Increase i2c timeout for NVIDIA GPU controller
    options i2c_nvidia_gpu adapter_timeout=20000

    # Note: ucsi_ccg_timeout parameter doesn't exist in kernel 6.17
    # The driver uses a hardcoded timeout which we can't override
  '';

  # ========== KERNEL MODULES ==========
  # Load both USB-C controller drivers
  boot.kernelModules = [
    "thunderbolt"
    "typec"
    "typec_ucsi"
    "ucsi_acpi"
    # Analogix ANX7411 (Intel i2c bus)
    "anx7411"
    # NVIDIA i2c controller (may timeout but shouldn't break boot)
    "i2c_nvidia_gpu"
    "ucsi_ccg"
  ];

  boot.initrd.kernelModules = [
    "anx7411"
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

    # USB-C/Thunderbolt - Force enable
    "thunderbolt.dyndbg=+p"
    "typec.dyndbg=+p"
    "ucsi_acpi.dyndbg=+p"
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
