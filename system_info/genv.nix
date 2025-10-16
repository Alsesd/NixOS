{pkgs, ...}: {
  environment.variables = {
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    GSK_RENDERER = "ngl";
    GBM_BACKEND = "nvidia-drm";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config.common.default = "*";
  };

  environment.sessionVariables = {
    DEFAULT_FILE_MANAGER = "thunar";
    FILE_MANAGER = "thunar";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  xdg.mime.defaultApplications = {
    "inode/directory" = ["thunar.desktop"];
  };

  services.gvfs.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.enable = true;
}
