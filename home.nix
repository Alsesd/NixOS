{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home-module/waybar.nix
  ];

  stylix.targets.hyprland.enable = true;
  stylix.targets.nixos-icons.enable = true;
  stylix.targets.waybar.enable = true;
  stylix.targets.cava.rainbow.enable = true;
  stylix.targets.rofi.enable = true;
  stylix.targets.kitty = {
    enable = true;
    variant256Colors = true;
  };
  home.username = "alsesd";
  home.homeDirectory = "/home/alsesd";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    waybar
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
