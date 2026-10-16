_: {
  flake.nixosModules.my-ajclock = {pkgs, ...}: let
    pythonEnv = pkgs.python3.withPackages (ps: [
      ps.hidapi
    ]);
    pkg = pkgs.stdenv.mkDerivation (finalAttrs: {
      pname = "my-ajclock";
      version = "1.0.0";

      src = pkgs.fetchFromGitHub {
        owner = "mstoiakevych";
        repo = "ajazz-clock-sync";
        rev = "v${finalAttrs.version}";
        hash = "sha256-llo2bFv0CSlcTN8k6EXKY9DgF/vVuGAoYXIDzUhzAgQ=";
      };

      nativeBuildInputs = [pkgs.makeWrapper];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/share/ajazz-clock-sync
        cp linux/ajazz_daemon.py $out/share/ajazz-clock-sync/ajazz_daemon.py

        makeWrapper ${pythonEnv}/bin/python $out/bin/my-ajclock \
          --add-flags "$out/share/ajazz-clock-sync/ajazz_daemon.py"

        runHook postInstall
      '';

      meta = {
        description = "Background daemon to sync system time to Ajazz wireless mouse docks";
        homepage = "https://github.com/mstoiakevych/ajazz-clock-sync";
        license = pkgs.lib.licenses.mit;
        platforms = pkgs.lib.platforms.linux;
        mainProgram = "my-ajclock";
      };
    });
  in {
    environment.systemPackages = [pkg];
    systemd.services.my-ajclock = {
      description = "Ajazz Clock Sync Daemon";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkg}/bin/my-ajclock";
        Restart = "always";
        RestartSec = 5;
        User = "root";
      };
    };
  };
}
