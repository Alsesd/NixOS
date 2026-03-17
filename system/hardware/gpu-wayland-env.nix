{
  config,
  pkgs,
  ...
}: {
  # ============================================================================
  # HARDWARE & GRAPHICS (NVIDIA)
  # ============================================================================
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      libvdpau-va-gl
      intel-media-driver
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      vulkan-validation-layers
    ];
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;

    powerManagement = {
      enable = true;
      finegrained = false;
    };
    nvidiaPersistenced = true;

    forceFullCompositionPipeline = false;
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "nvidia.NVreg_UsePageAttributeTable=1" # ADD: better memory perf
    "pcie_aspm=off"
    "intel_pstate=active"
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common.default = ["gtk"];
      niri = {
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      };
    };
  };

  # Поддержка XWayland
  programs.xwayland.enable = true;

  # ============================================================================
  # FILE MANAGER & SERVICES
  # ============================================================================
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services = {
    gvfs.enable = true; # Монтирование (флешки, сеть)
    tumbler.enable = true; # Генерация миниатюр
    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };
  };

  xdg.mime = {
    enable = true; # Ensure this is set to true
    defaultApplications = {
      "inode/directory" = ["thunar.desktop"]; # Must be a list [ ]
      "application/pdf" = ["evince.desktop"];
      "text/plain" = ["gedit.desktop"];
      "image/jpeg" = ["eog.desktop"];
      "image/png" = ["eog.desktop"];
      "x-scheme-handler/file" = ["thunar.desktop"];
    };
  };

  # ============================================================================
  # ENVIRONMENT & VARIABLES
  # ============================================================================
  environment = {
    systemPackages = with pkgs; [
      wayland-utils
      wayland-protocols
      wev
      xdg-utils
      xdg-user-dirs

      qt5.qtwayland
      qt6.qtwayland
      gtk3
      gtk4

      # Кастомный скрипт (из старого xdg.nix)
      (writeShellScriptBin "xdg-file-manager" ''
        exec ${pkgs.thunar}/bin/thunar "$@"
      '')
    ];

    sessionVariables = {
      # --- General Wayland ---
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";
      # GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      # SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      WLR_RENDERER = "vulkan";

      # --- Desktop Identity ---
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";

      # --- File Manager Defaults ---
      DEFAULT_FILE_MANAGER = "thunar";
      FILE_MANAGER = "thunar";

      # --- NVIDIA Specifics ---
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";

      WLR_NO_HARDWARE_CURSORS = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # Force immediate buffer swaps, reduces stutter when switching windows
      __GL_YIELD = "USLEEP";
      # Reduce Vulkan/GL pipeline stalls
      __GL_MaxFramesAllowed = "1";
      NVD_BACKEND = "direct";
      __GL_SYNC_TO_VBLANK = "0"; # don't wait for vblank on every frame
      KWIN_DRM_USE_EGL_STREAMS = "0"; # not kwin but good practice
    };
  };
}
