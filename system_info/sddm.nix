{pkgs, ...}: {
  # Disable GDM
  services.displayManager.gdm.enable = false;
  
  # Enable SDDM with Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    # Set default session
    settings = {
      General = {
        # Use Wayland compositor
        DisplayServer = "wayland";
        
        # Enable numlock by default
        Numlock = "on";
        
        # Set login screen on external monitor
        GreeterEnvironment = "QT_QPA_PLATFORM=wayland";
      };
      
      # Wayland-specific settings
      Wayland = {
        SessionDir = "/run/current-system/sw/share/wayland-sessions";
      };
      
      # X11 settings (fallback)
      X11 = {
        SessionDir = "/run/current-system/sw/share/xsessions";
      };
      
      # Users settings
      Users = {
        MaximumUid = 60000;
        MinimumUid = 1000;
      };
    };
    
    # Use a nice theme
    theme = "breeze";
  };
  
  # Required packages for SDDM
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.sddm-kcm
    kdePackages.breeze
  ];
  
  # Set wallpapers for SDDM
  environment.etc."sddm.conf.d/wallpaper.conf".text = ''
    [General]
    background=${./utility/wallpaper1.png}
  '';
  
  # Copy wallpapers to system location
  environment.etc."backgrounds/wallpaper1.png".source = ./utility/wallpaper1.png;
  environment.etc."backgrounds/wallpaper2.png".source = ./utility/wallpaper2.png;
}