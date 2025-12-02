{pkgs, ...}: {
  stylix = {
    enable = true;

    # Enable home-manager integration
    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };

    # Primary wallpaper - Stylix will use this for color scheme and default wallpaper

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

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

    # Icon theme configuration
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    # GTK theme settings
    targets.gtk.enable = true;
  };

  # Configure GTK settings
  programs.dconf.enable = true;
}
