{
  pkgs,
  inputs,
  ...
}: let
<<<<<<< HEAD
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
=======
  # an exhaustive example can be found in flake.nix
  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
    theme = "rei"; # select the config of your choice
  };
in {
  # include the test package which can be run using test-sddm-silent
  environment.systemPackages = [sddm-theme sddm-theme.test];
  qt.enable = true;
  services.displayManager.sddm = {
    package = pkgs.kdePackages.sddm; # use qt6 version of sddm
    enable = true;
    wayland.enable = true;
    theme = sddm-theme.pname;
    # the following changes will require sddm to be restarted to take
    # effect correctly. It is recomend to reboot after this
    extraPackages = sddm-theme.propagatedBuildInputs;
    settings = {
      # required for styling the virtual keyboard
      General = {
        GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };
>>>>>>> d249a75 (ini)
}
