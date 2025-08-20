{pkgs, ...}: {
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true; # Enable Wayland support for SDDM

    # Let Stylix handle the theming, but you can still use a custom theme
    # Comment out the theme line to let Stylix theme SDDM
    #theme = "pixel_sakura";
  };

  services.xserver.enable = true;
  environment.systemPackages = with pkgs; [
    sddm-astronaut # Contains pixel_sakura theme
    kdePackages.sddm-kcm # KDE configuration module for SDDM
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];
}
