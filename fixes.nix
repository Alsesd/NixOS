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

  # Enable Steam with FHS environment
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;

    # CRITICAL: Extra packages for Proton compatibility
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    # CRITICAL: This adds all necessary runtime libraries
    package = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          # ===== Core System Libraries =====
          glibc
          stdenv.cc.cc.lib
          gcc.cc.lib

          # ===== X11/Display =====
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          xorg.libXrandr
          xorg.libXxf86vm
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrender
          xorg.libX11
          xorg.libxcb
          xorg.libXau
          xorg.libXdmcp

          # ===== Graphics/Vulkan =====
          vulkan-loader
          vulkan-tools
          vulkan-validation-layers
          vulkan-extension-layer
          libGL
          libGLU
          mesa
          mesa.drivers

          # ===== Audio =====
          libpulseaudio
          alsa-lib
          alsa-plugins
          libsndfile
          libogg
          libvorbis
          flac
          pipewire

          # ===== Networking =====
          curl
          openssl
          libkrb5
          keyutils

          # ===== Font/Text Rendering =====
          fontconfig
          freetype
          harfbuzz
          fribidi
          cairo
          pango

          # ===== GTK/UI =====
          gtk3
          gtk3-x11
          at-spi2-atk
          at-spi2-core
          dbus
          glib

          # ===== Media/Codecs =====
          ffmpeg
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly

          # ===== SDL =====
          SDL2
          SDL2_mixer
          SDL2_image
          SDL2_ttf
          SDL

          # ===== Image Libraries =====
          libpng
          libjpeg
          libtiff
          libwebp

          # ===== Compression =====
          zlib
          bzip2
          xz
          zstd

          # ===== System/Hardware =====
          systemd
          libudev0-shim
          libusb1
          libpcap

          # ===== Input =====
          libevdev
          libinput

          # ===== Additional =====
          fmodex
          libgdiplus
          libxkbcommon
          wayland

          # ===== NVIDIA specific =====
          libva
          libvdpau

          # ===== CRITICAL: 32-bit libraries =====
          pkgsi686Linux.glibc
          pkgsi686Linux.stdenv.cc.cc.lib
          pkgsi686Linux.libGL
          pkgsi686Linux.mesa
          pkgsi686Linux.libpulseaudio
          pkgsi686Linux.alsa-lib
          pkgsi686Linux.libvorbis
          pkgsi686Linux.SDL2
        ];
    };
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

    extraPackages = with pkgs; [
      # Vulkan
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer

      # NVIDIA specific
      nvidia-vaapi-driver

      # Additional
      libvdpau-va-gl
      libva
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
      vulkan-validation-layers
    ];
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
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "524288";
    }
  ];

  # ========== ENVIRONMENT VARIABLES ==========
  environment.sessionVariables = {
    # Steam
    STEAM_FORCE_DESKTOPUI_SCALING = "1.0";

    # CRITICAL: Enable Steam Runtime
    STEAM_RUNTIME = "1";
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";

    # For better compatibility
    SDL_VIDEODRIVER = "x11"; # Many Proton games work better with X11

    # Proton
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";

    # Vulkan
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json";

    # Uncomment for debugging:
    # PROTON_LOG = "1";
    # DXVK_LOG_LEVEL = "info";
    # DXVK_HUD = "fps,devinfo,memory";
    # WINEDEBUG = "+all";
  };

  # ========== ADDITIONAL SYSTEM PACKAGES ==========
  environment.systemPackages = with pkgs; [
    # For missing library debugging
    patchelf
    file

    # Steam runtime helper
    steam-run

    # Proton utilities
    protontricks
    protonup-qt
  ];

  # ========== UDEV RULES FOR CONTROLLERS ==========
  services.udev.extraRules = ''
    # Steam Controller
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"

    # PS4/PS5 Controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", MODE="0666"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", MODE="0666"

    # Xbox Controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", MODE="0666"
  '';
}
