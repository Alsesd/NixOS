{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home-module/waybar.nix
    inputs.nix-colors.homeManagerModules.default
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  programs = {
    vscode.enable = true;
    kitty.enable = true;
    rofi.enable = true;
  };
  #stylix.targets = {
  #  waybar.enable = false; # We have custom waybar config
  #  kitty.enable = true;
  #  rofi-wayland.enable = true;
  #  vscode.enable = true;
  #};

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
