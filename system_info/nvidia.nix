# ============================================================================
# NVIDIA Configuration
# ============================================================================
# Настройки для NVIDIA GPU с поддержкой Wayland
# ============================================================================
{
  config,
  pkgs,
  ...
}: {
  # === Graphics ===
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Поддержка 32-bit приложений (Steam, Wine)

    extraPackages = with pkgs; [
      # NVIDIA специфичные пакеты
      nvidia-vaapi-driver # VA-API для аппаратного ускорения видео

      # Vulkan
      vulkan-loader
      vulkan-validation-layers

      # OpenCL
      # ocl-icd
    ];
  };

  # === NVIDIA Driver ===
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting необходим для Wayland
    modesetting.enable = true;

    # Использовать open-source модули ядра
    # Если есть проблемы - поставьте false
    open = true;

    # Настройки NVIDIA
    nvidiaSettings = true;

    # Использовать последний драйвер
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Power Management
    powerManagement = {
      enable = true;
      # Экспериментальная функция - отключает GPU когда не используется
      # finegrained = true;
    };
  };

  # === Environment Variables для Wayland + NVIDIA ===
  environment.variables = {
    # === Wayland Backend ===
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";

    # === Desktop Session ===
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";

    # === NVIDIA Specific ===
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";

    # === Hardware Acceleration ===
    NVD_BACKEND = "direct";
    MOZ_ENABLE_WAYLAND = "1";

    # === Rendering ===
    GSK_RENDERER = "ngl";
    WLR_NO_HARDWARE_CURSORS = "1"; # Фикс для курсора на некоторых GPU
  };

  # === Kernel Modules ===
  boot.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
}
