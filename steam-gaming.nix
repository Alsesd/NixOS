# ============================================================================
# Steam & Gaming Configuration
# ============================================================================
# Handles Steam, Proton, and game compatibility
# ============================================================================
{pkgs, ...}: {
  # ========== STEAM ==========
  programs.steam = {
    enable = true;

    # Open firewall ports for Steam
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    # Enable gamescope session
    gamescopeSession.enable = true;

    # Additional packages for Steam
    extraCompatPackages = with pkgs; [
      proton-ge-bin # GloriousEggroll's Proton - often better than official
    ];
  };

  # ========== GAMEMODE ==========
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
        ioprio = 0;
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # ========== GAMING PACKAGES ==========
  environment.systemPackages = with pkgs; [
    # Performance monitoring
    mangohud # FPS overlay
    goverlay # GUI for MangoHud configuration

    # Game launchers
    lutris
    heroic # Epic Games & GOG

    # Utilities
    gamescope # Micro-compositor for games
    gamemode

    # Proton utilities
    protontricks
    protonup-qt # Manage Proton versions

    # Debugging
    vulkan-tools # vulkaninfo
    glxinfo

    # Wine dependencies (for Proton)
    wine
    wine64
    winetricks
  ];

  # ========== XWAYLAND SATELLITE ==========
  # For games that need X11 but you're on Wayland
  # This is crucial for many Proton games!
  systemd.user.services.xwayland-satellite = {
    description = "XWayland Satellite";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :0";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  # ========== ENVIRONMENT VARIABLES ==========
  environment.sessionVariables = {
    # Steam scaling
    STEAM_FORCE_DESKTOPUI_SCALING = "1.0";

    # MangoHud
    MANGOHUD = "1";

    # Enable Proton logging (for debugging)
    # Uncomment these if you need to troubleshoot:
    # PROTON_LOG = "1";
    # PROTON_USE_WINED3D = "0"; # Force Vulkan (default)
    # DXVK_LOG_LEVEL = "info";
    # DXVK_HUD = "fps,devinfo,memory";

    # Force games to use XWayland if Wayland causes issues
    # Uncomment if games have black screen or input issues:
    # SDL_VIDEODRIVER = "x11"; # Force SDL2 games to use X11
    # GDK_BACKEND = "x11"; # Force GTK apps to use X11
  };

  # ========== KERNEL MODULES ==========
  boot.kernelModules = [
    "uinput" # Required for some game controllers
  ];

  # ========== UDEV RULES ==========
  # Better permissions for gaming devices
  services.udev.extraRules = ''
    # Steam controller
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"

    # Nintendo Switch Pro controller
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666"

    # PS4/PS5 controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", MODE="0666"

    # Xbox controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", MODE="0666"
  '';

  # ========== SYSTEM LIMITS ==========
  security.pam.loginLimits = [
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
}
