{
  config,
  pkgs,
  ...
}: let
  # Atelier Lakeside colors to match your Stylix theme
  lakeside_bg = "#161b1d"; # Dark background
  lakeside_fg = "#7ea2b4"; # Light blue-gray text
  lakeside_blue = "#398bc6"; # Blue accent
  lakeside_green = "#568c3b"; # Green accent
  lakeside_yellow = "#8a8a0f"; # Yellow accent
  lakeside_red = "#d22d72"; # Red/pink accent
  lakeside_orange = "#935c25"; # Orange accent
in {
  programs.fastfetch = {
    enable = true;
    package = pkgs.fastfetch;
    settings = {
      logo = {
        source = "nixos_small";
        height = 8;
        width = 20;
        padding = {
          top = 2;
          left = 2;
        };
      };

      modules = [
        {
          type = "title";
          format = "{#${lakeside_blue}}┌─ {#${lakeside_fg}}System Info {#${lakeside_blue}}─┐";
        }
        {
          type = "os";
          key = "{#${lakeside_green}}├ OS";
          keyColor = lakeside_green;
        }
        {
          type = "host";
          key = "{#${lakeside_green}}├ Host";
          keyColor = lakeside_green;
        }
        {
          type = "kernel";
          key = "{#${lakeside_green}}├ Kernel";
          keyColor = lakeside_green;
        }
        {
          type = "uptime";
          key = "{#${lakeside_green}}└ Uptime";
          keyColor = lakeside_green;
        }
        "break"
        {
          type = "title";
          format = "{#${lakeside_yellow}}┌─ {#${lakeside_fg}}Hardware {#${lakeside_yellow}}─┐";
        }
        {
          type = "cpu";
          key = "{#${lakeside_yellow}}├ CPU";
          keyColor = lakeside_yellow;
        }
        {
          type = "gpu";
          key = "{#${lakeside_yellow}}├ GPU";
          keyColor = lakeside_yellow;
        }
        {
          type = "memory";
          key = "{#${lakeside_yellow}}├ RAM";
          keyColor = lakeside_yellow;
        }
        {
          type = "disk";
          key = "{#${lakeside_yellow}}└ Disk";
          keyColor = lakeside_yellow;
        }
        "break"
        {
          type = "title";
          format = "{#${lakeside_red}}┌─ {#${lakeside_fg}}Environment {#${lakeside_red}}─┐";
        }
        {
          type = "wm";
          key = "{#${lakeside_red}}├ WM";
          keyColor = lakeside_red;
        }
        {
          type = "terminal";
          key = "{#${lakeside_red}}├ Term";
          keyColor = lakeside_red;
        }
        {
          type = "shell";
          key = "{#${lakeside_red}}├ Shell";
          keyColor = lakeside_red;
        }
        {
          type = "packages";
          key = "{#${lakeside_red}}└ Pkgs";
          keyColor = lakeside_red;
        }
      ];
    };
  };
}
