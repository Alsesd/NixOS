# Add this to your home.nix after Stylix is working
{
  config,
  lib,
  ...
}: {
  # Override Stylix's hyprpaper configuration for dual monitor setup
  services.hyprpaper = lib.mkForce {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      # Preload both wallpapers
      preload = [
        "~/.config/nixos/modules/wallpaper1.png" # Primary wallpaper (also used by Stylix for colors)
        "~/.config/nixos/modules/wallpaper2.png" # Secondary wallpaper
      ];

      # Set different wallpaper for each monitor
      wallpaper = [
        "eDP-1,~/.config/nixos/modules/wallpaper2.png" # Laptop screen
        "HDMI-A-4,~/.config/nixos/modules/wallpaper1.png" # External monitor
      ];
    };
  };
}
