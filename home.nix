{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home-module/eww-widgets/eww.nix
    ./home-module/nixvim.nix
  ];

  home.username = "alsesd";
  home.homeDirectory = "/home/alsesd";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    discord
    steam
    qbittorrent
    vlc
    vscode
    slack
    gamescope
    ayugram-desktop
    easyeffects
    protonup-qt
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
  ];
	programs.yazi = {
  enable = true;
  enableZshIntegration = true; # чтобы 'cd' из yazi менял директорию в шелле
  settings = {
    manager = {
      show_hidden = true;
      sort_by = "mtime"; # сортировка по времени изменения (удобно для логов)
    };
  };
};
}
