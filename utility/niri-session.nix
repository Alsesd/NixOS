{pkgs, ...}: {
  # Создаём правильную Wayland сессию для Niri
  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "niri";
      desktopName = "Niri";
      comment = "Niri - scrollable-tiling Wayland compositor";
      exec = "${pkgs.niri}/bin/niri-session";
      icon = "niri";
      type = "Application";
    })
  ];

  # Убедимся что сессия в правильном месте
  services.displayManager.sessionPackages = [pkgs.niri];
}
