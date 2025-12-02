# ============================================================================
# System Fixes - Enhanced for Gaming (HOI4/Proton)
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

  # ========== KERNEL BLACKLIST ==========
  boot.blacklistedKernelModules = [
    "psmouse" # Старый драйвер тачпада (конфликтует с libinput)
    "ucsi_ccg" # USB Type-C контроллер на NVIDIA GPU (вызывает I2C timeout)
  ];

  # ========== MODULE OPTIONS ==========
  boot.extraModprobeConfig = ''
    # ===== Intel Wi-Fi =====
    options iwlwifi power_save=0 11n_disable=0 bt_coex_active=0
    options iwlmvm power_scheme=1

    # ===== NVIDIA for Gaming =====
    # Prevent GPU from entering power-saving states that cause issues
    options nvidia NVreg_PreserveVideoMemoryAllocations=1
    options nvidia NVreg_TemporaryFilePath=/var/tmp
  '';

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

  # Enable GameMode for performance
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

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # ========== KERNEL PARAMETERS FOR GAMING ==========
  boot.kernelParams = [
    # NVIDIA
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"

    # PCIe optimizations
    "pcie_aspm=off"

    # Performance
    "mitigations=off" # Better performance, slightly less secure
    "split_lock_detect=off"

    # Memory management
    "transparent_hugepage=always"
  ];

  # ========== OPENGL/VULKAN 32-BIT SUPPORT ==========
  # Critical for Proton games
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Essential for 32-bit games and Proton
  };

  # ========== SYSTEM LIMITS FOR GAMING ==========
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
    # Force X11 backend for problematic Wayland apps
    # Uncomment if Steam/games have issues on Wayland
    # STEAM_FORCE_DESKTOPUI_SCALING = "1.0";

    # Proton debugging (uncomment to enable verbose logging)
    # PROTON_LOG = "1";
    # DXVK_LOG_LEVEL = "info";
    # DXVK_HUD = "fps,devinfo,memory";
  };
}
