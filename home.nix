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

  stylix.targets = {
    waybar.enable = false; # We have custom waybar config
    kitty.enable = true;
    rofi.enable = true;
    gtk.enable = true;
    firefox.enable = true;
    vscode.enable = true;
  };
  hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
    };
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
