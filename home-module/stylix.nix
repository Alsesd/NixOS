# Create this as ./home-modules/stylix.nix
{...}: {
  stylix.targets = {
    # Enable most applications
    alacritty.enable = true;
    bat.enable = true;
    btop.enable = true;
    fzf.enable = true;
    gtk.enable = true;
    kitty.enable = true;

    # Disable specific ones we want to configure manually (like ZaneyOS)
    waybar.enable = false; # We'll use custom waybar config
    rofi.enable = false; # We'll use custom rofi config
    hyprland.enable = false; # We'll configure Hyprland manually
    hyprlock.enable = false; # Manual hyprlock config

    # Qt theming
    qt.enable = true;

    # Terminal and shell theming
    fish.enable = true;
    zsh.enable = true;
    bash.enable = true;
  };
}
