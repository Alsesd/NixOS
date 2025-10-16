{
  pkgs,
  inputs,
  ...
}: let
  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
    theme = "rei";
  };
in {
  environment.systemPackages = [
    sddm-theme
    sddm-theme.test
    pkgs.kdePackages.sddm
  ];

  qt.enable = true;

  services.displayManager.sddm = {
    package = pkgs.kdePackages.sddm;
    enable = true;
    wayland.enable = true;
    theme = sddm-theme.pname;

    extraPackages = sddm-theme.propagatedBuildInputs;

    settings = {
      General = {
        DisplayServer = "wayland";
        GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard,QT_QPA_PLATFORM=wayland";
        InputMethod = "qtvirtualkeyboard";
        Numlock = "on";
      };

      Wayland = {
        # ВАЖНО: НЕ указываем CompositorCommand - пусть SDDM использует свой композитор (labwc)
        SessionDir = "/run/current-system/sw/share/wayland-sessions";
      };

      Users = {
        MaximumUid = 60000;
        MinimumUid = 1000;
      };
    };
  };

  # Обои для SDDM
  environment.etc."sddm.conf.d/wallpaper.conf".text = ''
    [General]
    background=/etc/backgrounds/wallpaper1.png
  '';

  environment.etc."backgrounds/wallpaper1.png".source = ../utility/wallpaper1.png;
  environment.etc."backgrounds/wallpaper2.png".source = ../utility/wallpaper2.png;

  # Logind настройки
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
}
