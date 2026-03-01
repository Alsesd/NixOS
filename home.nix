{
  pkgs,
  inputs,
  vars,
  ...
}: {
  imports = [
    ./home-module/nixvim.nix
    ./home-module/noctalia.nix
    ./home-module/zed.nix
    ./home-module/just.nix
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    discord
    steam
    qbittorrent
    vlc
    slack
    gamescope
    gamemode
    ayugram-desktop
    easyeffects
    protonup-qt
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
  ];
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = true; # чтобы 'cd' из yazi менял директорию в шелле
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "mtime"; # сортировка по времени изменения (удобно для логов)
      };
    };
  };
}
