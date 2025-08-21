{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home-module/waybar.nix
    ./home-module/bash.nix
    ./home-module/kitty.nix
    ./home-module/fastfetch.nix
    ./home-module/starship.nix
    ./home-module/hyprland.nix
  ];

  home.username = "alsesd";
  home.homeDirectory = "/home/alsesd";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    google-chrome
    discord
    ayugram-desktop
    steam
    gamescope
    vscode
    obsidian
    qbittorrent
  ];

  xdg.configFile = {
    # Keep any non-theme files you need
  };

  # Remove xsettingsd - Stylix handles theme coordination
  services = {
    # Other services you need
  };

  programs.home-manager.enable = true;
}
