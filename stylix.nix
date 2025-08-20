# Create this as ./stylix.nix in your config directory
{pkgs, ...}: {
  stylix = {
    enable = true;

    # Choose your wallpaper - this will generate your color scheme
    image = pkgs.fetchurl {
      url = "https://images.unsplash.com/photo-1506905925346-21bda4d32df4"; # Beautiful mountain landscape
      sha256 = "sha256-8JhBN0tSZ3okmhHa8cNTTvP5cG4M/O5xElLdRhPwR8M="; # You'll need to get actual hash
    };

    # Or use a local wallpaper:
    # image = ./path/to/your/wallpaper.jpg;

    # Base16 scheme (alternative to image-based theming)
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    # System-wide settings
    polarity = "dark"; # or "light"

    # Font configuration
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        terminal = 14;
        desktop = 11;
        popups = 12;
      };
    };

    # Cursor theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # What to theme (we'll be selective like ZaneyOS)
    targets = {
      # Enable most targets
      grub.enable = true;
      nixos-icons.enable = true;
      plymouth.enable = true;
      console.enable = true;

      # Desktop environment targets
      gtk.enable = true;

      # We'll handle these manually for better control
      gnome.enable = false;
      hyprland.enable = false; # We'll configure manually
    };

    # Transparency settings
    opacity = {
      applications = 1.0;
      terminal = 0.9;
      desktop = 1.0;
      popups = 0.95;
    };
  };
}
