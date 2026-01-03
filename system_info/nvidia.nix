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
      vulkan-tools 
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Power management - can cause issues with some games
    # Disable if you experience crashes or black screens
    powerManagement = {
      enable = false; # Set to true only if suspend/resume works well
      finegrained = false;
    };

    forceFullCompositionPipeline = false;
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1" # KMS для NVIDIA
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "pcie_aspm=off" # Disable PCIe power management

    # Additional gaming optimizations
    "nvidia.NVreg_EnableGpuFirmware=0" # Can help with stability
  ];

  # ========== ENVIRONMENT VARIABLES ==========
  environment.variables = {
    # Wayland support
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";

    # NVIDIA specific
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";

    # Mozilla/Firefox
    MOZ_ENABLE_WAYLAND = "1";

    # Cursor workaround for NVIDIA+Wayland
    WLR_NO_HARDWARE_CURSORS = "1";

    # Gaming optimizations
    # __GL_THREADED_OPTIMIZATION = "1";
    # __GL_SHADER_DISK_CACHE = "1";
    # __GL_SHADER_DISK_CACHE_PATH = "/tmp/nvidia-shader-cache";

    # Vulkan ICD - ensures Proton finds the right driver
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json";
  };

  # systemd.tmpfiles.rules = [
  #   "d /tmp/nvidia-shader-cache 1777 root root 10d"
  # ];
}
