{ pkgs, config, ... }: {

  home-manager.users.alsesd = {
  # Fix for rofi-calc on Wayland
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];

  home.packages = with pkgs; [
    rofi-wayland
    rofi-calc
    libqalculate # High-performance math engine
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [ pkgs.rofi-calc ];
    
    extraConfig = {
      # Enable the three modes you want
      modi = "drun,calc,filebrowser";
      show-icons = true;
      display-drun = "Apps";
      display-calc = "Calc";
      display-filebrowser = "Files";

      # Filebrowser settings
      filebrowser = {
        directory = "/home/alsesd"; # Starts in your home
        directories-first = true;
        sorting-method = "name";
      };

      # Calc settings
      calc-command = "echo -n '{result}' | wl-copy"; # Auto-copies math results to clipboard
    };
  };
};
}