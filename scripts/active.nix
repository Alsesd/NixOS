{pkgs, ...}: {
  imports = [
    ./toggle-tray.nix #Open tray widget on active monitor
    ./xdg-file-manager.nix #Thunar as default file manager
    ./plug.nix #Ventoy plugson script
    ./wallpaper-start.nix #Set wallpaper on active monitor
  ];
  systemd.user.services.wallpaper-start.enable = true;
}
