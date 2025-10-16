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
        "./wallpaper1.png" # Primary wallpaper (also used by Stylix for colors)
        "./wallpaper2.png" # Secondary wallpaper
      ];

      wallpaper = [
        "./wallpaper1.png" # Laptop screen
        "//wallpaper2.png" # External monitor
      ];
    };
  };
}
