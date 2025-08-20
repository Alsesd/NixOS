{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./home-modules/waybar.nix
  ];

  home.username = "alsesd";
  home.homeDirectory = "/home/alsesd";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    hello
    (writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')

    # Remove manual theme packages - Stylix will handle these
    # We'll keep them for now during transition
    papirus-icon-theme
    adwaita-icon-theme
    gnome-themes-extra
    arc-theme
    materia-theme
  ];

  # Simplified - let Stylix handle most theming
  # Keep minimal manual config for compatibility
  gtk = {
    enable = true;
    # Let Stylix handle theme selection
    # Remove manual theme configuration
  };

  qt = {
    enable = true;
    # Let Stylix handle Qt theming
  };

  # Clean up manual session variables - Stylix handles these
  home.sessionVariables = {
    # Keep any non-theme related variables
    # Remove theme-related variables
  };

  # Simplified program configurations
  programs = {
    rofi = {
      enable = true;
      # Stylix will theme this automatically
    };
  };

  # Remove manual XDG theme configurations - Stylix handles these
  # Keep this minimal during transition
  xdg.configFile = {
    # Keep any non-theme files you need
  };

  # Remove xsettingsd - Stylix handles theme coordination
  services = {
    # Other services you need
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
