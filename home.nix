{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./home-module/terminal/terminal.nix

    ./home-module/eww-widgets/eww.nix

    ./home-module/niri/niri.nix
    ./home-module/niri/waybar.nix
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
    inputs.zen-browser.packages."${stdenv.hostPlatform.system}".default
  ];
  programs.nixvim.enable = true;
}
