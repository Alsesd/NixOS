{
  flake.nixosModules.stylix = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      papirus-icon-theme
      base16-schemes
      dejavu_fonts
      nerd-fonts.jetbrains-mono
      inter # Explicitly adding Inter since you use it for sansSerif
    ];

    stylix = {
      enable = true;

      homeManagerIntegration = {
        autoImport = true;
        followSystem = true;
      };

      # Using the built-in Gruvbox scheme from your packages
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
        };
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 12;
          terminal = 15;
          desktop = 11;
          popups = 10;
        };
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 18;
      };

      opacity = {
        applications = 0.75;
        terminal = 0.7;
        desktop = 1.0;
        popups = 0.9;
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };

      # Enable GTK theming for apps like Thunar or Polkit agent
      targets.gtk.enable = true;

      # Enable Qt theming if you ever use Qt apps (like some Steam components)
      targets.qt.enable = true;
    };

    programs.dconf.enable = true;
  };
}
