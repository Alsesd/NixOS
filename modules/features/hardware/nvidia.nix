{
  flake.nixosModules.nvidia = {
    config,
    pkgs,
    ...
  }: {
    # ============================================================================
    # HARDWARE & GRAPHICS (NVIDIA)
    # ============================================================================
    services = {
      xserver.videoDrivers = ["nvidia"];
      udev.extraRules = ''
        # NVIDIA device nodes - fix permissions
        KERNEL=="nvidia[0-9]*", MODE="0666"
        KERNEL=="nvidiactl", MODE="0666"
        KERNEL=="nvidia-uvm", MODE="0666"
        KERNEL=="nvidia-uvm-tools", MODE="0666"
      '';
      gvfs.enable = true; # Монтирование (флешки, сеть)
      tumbler.enable = true; # Генерация миниатюр
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          nvidia-vaapi-driver
          vulkan-loader
          vulkan-tools
          libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          vulkan-loader
        ];
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;

        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;

        powerManagement = {
          enable = true;
          finegrained = false;
        };
        nvidiaPersistenced = true;

        forceFullCompositionPipeline = false;

        prime = {
          sync.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      nvidia-container-toolkit.enable = true;
    };

    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "pcie_aspm=off"
      "intel_pstate=active"
    ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
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

        libdisplay-info

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

        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        # Force immediate buffer swaps, reduces stutter when switching windows
        __GL_YIELD = "USLEEP";
        # Reduce Vulkan/GL pipeline stalls
        __GL_MaxFramesAllowed = "1";
        NVD_BACKEND = "direct";
        __GL_SYNC_TO_VBLANK = "0"; # don't wait for vblank on every frame
        KWIN_DRM_USE_EGL_STREAMS = "0"; # not kwin but good practice

        # --- VRR (Adaptive Sync / G-Sync) ---
        __GL_VRR_ALLOWED = "1";
        __GL_GSYNC_ALLOWED = "1";

        # --- Proton NVAPI & NVIDIA Reflex ---
        PROTON_ENABLE_NVAPI = "1";
        PROTON_HIDE_NVIDIA_GPU = "0";
        DXVK_STATE_CACHE = "1";
      };
    };
  };
}
