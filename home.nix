{pkgs, ...}: {
  imports = [
    ./home-module/bash.nix
    ./home-module/kitty.nix
    ./terminal/fastfetch.nix
    ./terminal/starship.nix

    ./home-module/eww-widgets/eww.nix

    ./home-module/niri/niri.nix
    ./home-module/niri/hyprpaper.nix
    ./home-module/niri/waybar.nix
    ./home-module/niri/mako.nix
    #./home-module/niri/swayidle.nix
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
    obsidian
    qbittorrent
    vlc
    vscode
    slack
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
