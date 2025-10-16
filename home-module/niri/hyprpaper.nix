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
        "~/.locaL/share/wallpaper1.png" # Primary wallpaper (also used by Stylix for colors)
        "~/.local/share/wallpaper2.png" # Secondary wallpaper
      ];
      main-wall = "~/.local/share/wallpaper1.png";
      # Set different wallpaper for each monitor
      wallpaper = [
        "~/.locaL/share/wallpaper1.png" # Laptop screen
        "~/.local/share/wallpaper2.png" # External monitor
      ];
    };
  };
}
