{
  pkgs,
  inputs,
  ...
}: {
  stylix = {
    enable = true;

    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };

    #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-lakeside.yaml";

    image = ./wallpaper.png;

    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 18;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono; # Fixed syntax
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

    opacity = {
      applications = 0.75;
      terminal = 0.7;
      desktop = 1.0;
      popups = 0.9;
    };
  };
}
