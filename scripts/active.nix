{pkgs, ...}: {
  imports = [
    ./toggle-tray.nix #Open tray widget on active monitor
    ./xdg-file-manager.nix #Thunar as default file manager
  ];
}
