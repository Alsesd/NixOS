# Add this to your home.nix after Stylix is working
{
  config,
  lib,
  ...
}: {
  services.hyprpaper = lib.mkForce {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      # Preload both wallpapers
      preload = [
        "~/.config/nixos/wallpapers/wallpaper1.png" # Primary wallpaper (also used by Stylix for colors)
        "~/.config/nixos/wallpapers/wallpaper2.png" # Secondary wallpaper
      ];
      main-wall = "~/.local/share/wallpaper1.png";
      # Set different wallpaper for each monitor
      wallpaper = [
        "~/.config/nixos/wallpapers/wallpaper1.png" # Laptop screen
        "~/.config/nixos/wallpapers/wallpaper2.png" # External monitor
      ];
    };
  };
}
