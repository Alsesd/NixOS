# Add this to your home.nix after Stylix is working
{
  config,
  lib,
  ...
}: {
  services.swaybg = lib.mkForce {
    enable = true;
    settings = {
      ipc = "on";

      wallpaper = [
        ".wallpaper1.png" # Laptop screen
        ".wallpaper2.png" # External monitor
      ];
    };
  };
}
