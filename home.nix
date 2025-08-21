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

  stylix.targets.hyprland.enable = true;
  stylix.targets.nixos-icons.enable = true;
  programs.targets.waybar.enable = true;
  programs.targets.cava.rainbow.enable = true;
  programs.targets.rofi.enable = true;
  programs.targets.kitty.enable = true;
.username = "alsesd";
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
