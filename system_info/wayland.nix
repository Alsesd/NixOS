# ============================================================================
# Wayland Configuration
# ============================================================================
# Общие настройки для Wayland окружения
# ============================================================================
{pkgs, ...}: {
  # === XDG Desktop Portal ===
  xdg.portal = {
    enable = true;

    # Порталы для различных функций
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk # GTK file picker
      xdg-desktop-portal-wlr # Screen sharing
    ];

    # Конфигурация портала
    config = {
      common = {
        default = ["gtk"];
      };
      niri = {
        default = ["gtk" "wlr"];
        "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
      };
    };
  };

  # === Programs ===
  programs = {
    # Wayland XDG utils
    xwayland.enable = true;

    # File manager
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    # XFConf для Thunar
    xfconf.enable = true;
  };

  # === Services ===
  services = {
    # GVFS для монтирования
    gvfs.enable = true;

    # Tumbler для превью
    tumbler.enable = true;

    # D-Bus
    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };
  };

  # === Environment ===
  environment = {
    # Системные пакеты
    systemPackages = with pkgs; [
      # Wayland tools
      wayland-utils
      wayland-protocols
      wev # Wayland event viewer (для отладки клавиш)

      # XDG utils
      xdg-utils
      xdg-user-dirs

      # Qt Wayland support
      qt5.qtwayland
      qt6.qtwayland

      # GTK
      gtk3
      gtk4
    ];

    # Переменные окружения для Wayland
    sessionVariables = {
      # Qt
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # GTK
      GDK_BACKEND = "wayland,x11";

      # Mozilla
      MOZ_ENABLE_WAYLAND = "1";

      # Clutter
      CLUTTER_BACKEND = "wayland";

      # SDL
      SDL_VIDEODRIVER = "wayland";

      # Electron
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
  };
}
