# Save this as: home-module/stylix-hyprland-target.nix
# This recreates the official Stylix Hyprland target functionality
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.stylix;
  colors = cfg.base16Scheme;
in {
  config = lib.mkIf (config.wayland.windowManager.hyprland.enable && cfg.enable) {
    # Apply Stylix colors to Hyprland
    wayland.windowManager.hyprland.settings = let
      rgb = color: "rgb(${color})";
      rgba = color: alpha: "rgba(${color}${alpha})";
    in {
      decoration.shadow.color = rgba colors.base00 "99";
      general = {
        "col.active_border" = rgb colors.base0D;
        "col.inactive_border" = rgb colors.base03;
      };
      group = {
        "col.border_inactive" = rgb colors.base03;
        "col.border_active" = rgb colors.base0D;
        "col.border_locked_active" = rgb colors.base0C;
        groupbar = {
          text_color = rgb colors.base05;
          "col.active" = rgb colors.base0D;
          "col.inactive" = rgb colors.base03;
        };
      };
      misc = {
        background_color = rgb colors.base00;
        disable_hyprland_logo = true;
      };
    };

    # Configure hyprpaper service
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        # Single wallpaper setup (we'll override this for dual monitor)
        preload = ["${cfg.image}"];
        wallpaper = [",${cfg.image}"];
      };
    };
  };
}
