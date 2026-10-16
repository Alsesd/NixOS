_: {
  flake.nixosModules.my-ajcontrol = {pkgs, ...}: let
    pkg = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "my-ajcontrol";
      version = "0.1.1";

      src = pkgs.fetchFromGitHub {
        owner = "Aiacos";
        repo = "ajazz-control-center";
        rev = "v${finalAttrs.version}";
        hash = "sha256-hW70W377bQ0XEZsiS0UQguGTGUln0WWyRYR+DKRHXAA=";
      };

      nativeBuildInputs = [
        pkgs.cmake
        pkgs.ninja
        pkgs.pkg-config
        pkgs.qt6.wrapQtAppsHook
      ];

      buildInputs = [
        pkgs.qt6.qtbase
        pkgs.qt6.qtdeclarative
        pkgs.qt6.qtsvg
        pkgs.qt6.qtwebsockets
        pkgs.hidapi
        pkgs.nlohmann_json
        pkgs.zlib
      ];

      cmakeFlags = [
        "-DAJAZZ_BUILD_TESTS=OFF"
        "-DAJAZZ_ENABLE_WERROR=OFF"
        "-DAJAZZ_USE_SYSTEM_DEPS=ON"
        "-DAJAZZ_INSTALL_UDEV_RULES=OFF"
      ];

      postInstall = ''
        mv $out/bin/ajazz-control-center $out/bin/my-ajcontrol
        if [ -f $out/share/applications/ajazz-control-center.desktop ]; then
          substituteInPlace $out/share/applications/ajazz-control-center.desktop \
            --replace-fail "Exec=ajazz-control-center" "Exec=my-ajcontrol"
        fi
      '';

      meta = {
        description = "Control center for AJAZZ devices (stream decks, keyboards, mice)";
        homepage = "https://github.com/Aiacos/ajazz-control-center";
        license = pkgs.lib.licenses.gpl3Plus;
        platforms = pkgs.lib.platforms.linux;
        mainProgram = "my-ajcontrol";
      };
    });
  in {
    environment.systemPackages = [pkg];
    services.udev.packages = [pkg];
  };
}
