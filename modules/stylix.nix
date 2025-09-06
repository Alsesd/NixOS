{pkgs, ...}: {
  stylix = {
    enable = true;

    # Enable home-manager integration
    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };

    # Primary wallpaper - Stylix will use this for color scheme and default wallpaper
    image = ./wallpaper2.png;
    polarity = "dark";

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 10;
      };
    };

    # Cursor configuration
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 18;
    };

    # Opacity settings
    opacity = {
      applications = 0.75;
      terminal = 0.7;
      desktop = 1.0;
      popups = 0.9;
    };
  };
}
