# ============================================================================
# System Fixes - Исправления всех проблем
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

  # ========== KERNEL PARAMETERS ==========
  boot.kernelParams = [
    "nvidia-drm.modeset=1" # KMS для NVIDIA
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Suspend для NVIDIA
    "pcie_aspm=off" # Отключить ASPM для всех PCIe
  ];

  # ========== MODULE OPTIONS ==========
  boot.extraModprobeConfig = ''
    # ===== NVIDIA =====
    options nvidia NVreg_RegistryDwords="RMUseSwI2c=0x01;RMI2cSpeed=100"

    # ===== Intel Wi-Fi =====
    # ВАЖНО: swcrypto=1 НЕ РАБОТАЕТ для iwlmvm!
    options iwlwifi power_save=0 11n_disable=0 bt_coex_active=0
    options iwlmvm power_scheme=1
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

  # ========== NVIDIA UDEV RULES ==========
  services.udev.extraRules = ''
    # Исправление прав доступа к NVIDIA device nodes
    KERNEL=="nvidia", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/nvidia*"
    KERNEL=="nvidia_uvm", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/nvidia-uvm"
    KERNEL=="nvidia_modeset", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/nvidia-modeset"
    KERNEL=="nvidiactl", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/nvidiactl"
  '';
}
