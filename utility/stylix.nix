{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    base16-schemes
  ];
  stylix = {
    enable = true;

    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };

    # targets.nixos-icons.enable = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter; # Намного современнее и полнее, чем DejaVu
        name = "Inter";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
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

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    targets.gtk.enable = true;
  };

  programs.dconf.enable = true;
}
