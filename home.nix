{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home-module/waybar.nix
    inputs.stylix.homeManagerModules.stylix
  ];

  #programs.hyprland.enable = true;
  programs.nixos-icons.enable = true;
  programs.waybar.enable = true;
  programs.cava.rainbow.enable = true;
  programs.rofi.enable = true;
  programs.kitty.enable = true;
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
