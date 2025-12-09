{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./home-module/terminal/bash.nix
    ./home-module/terminal/kitty.nix
    ./home-module/terminal/fastfetch.nix
    ./home-module/terminal/starship.nix

    ./home-module/eww-widgets/eww.nix

    ./home-module/niri/niri.nix
    ./home-module/niri/waybar.nix
    ./home-module/niri/mako.nix
  ];

  home.username = "alsesd";
  home.homeDirectory = "/home/alsesd";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    google-chrome
    discord
    steam
    obsidian
    qbittorrent
    vlc
    vscode
    slack
    jetbrains.pycharm-community-bin
    dbeaver-bin
  ];
}
