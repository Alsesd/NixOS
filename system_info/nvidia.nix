{
  config,
  pkgs,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Измените на false для проприетарного драйвера
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Используйте stable

    powerManagement = {
      enable = true;
      finegrained = false;
    };
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1" # KMS для NVIDIA
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Suspend для NVIDIA
    "pcie_aspm=off" # Отключить ASPM для всех PCIe
  ];

  boot.extraModprobeConfig = ''
    # Отключить I2C на NVIDIA GPU
    options nvidia NVreg_RegistryDwords="RMUseSwI2c=0x01;RMI2cSpeed=100"
  '';

  environment.variables = {
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
