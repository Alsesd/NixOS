{pkgs, ...}: {
  imports = [
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
    ayugram-desktop
    steam
    gamescope
    obsidian
    qbittorrent
    vlc
    vscode
    slack
  ];
<<<<<<< HEAD
=======
  programs.git = {
    enable = true;
    userName = "Alsesd";
    userEmail = "mr.alsesd@gmail.com";
  };
>>>>>>> d249a75 (ini)

  xdg.configFile = {
    # Keep any non-theme files you need
  };

<<<<<<< HEAD
  # Remove xsettingsd - Stylix handles theme coordination
=======
>>>>>>> d249a75 (ini)
  services = {
    # Other services you need
  };

  programs.home-manager.enable = true;
<<<<<<< HEAD
=======
  home.file = {
    "/home/alsesd/nixos-git" = {
      source = "/home/alsesd/.config/nixos/";
      recursive = true;
    };
  };
>>>>>>> d249a75 (ini)
}
