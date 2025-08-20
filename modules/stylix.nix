{
  config,
  pkgs,
  inputs,
  stylix,
  ...
}: {
  stylix = {
    # Base16 theme - you can change this to any theme you like
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";

    # Or you can use a custom wallpaper and let Stylix generate colors from it
    #image = ./wallpaper/wallpaper.jpg;

    # Cursor theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # Fonts
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
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

    # Opacity settings
    opacity = {
      applications = 1.0;
      terminal = 0.95;
      desktop = 1.0;
      popups = 1.0;
    };

    # Enable theming for various applications
    targets = {
      gtk.enable = true;
      nixos-icons.enable = true;
      plymouth.enable = true;
    };
  };

  # Enable Plymouth for beautiful boot screen
  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };
}
