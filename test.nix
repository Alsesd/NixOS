{
  config,
  pkgs,
  ...
}: {
  hardware.tuxedo-drivers.enable = true;
  boot.kernelModules = ["msr" "tuxedo_io" "tuxedo_keyboard"];

  environment.systemPackages = with pkgs; [
    tuxedo-control-center

    (writeShellScriptBin "maxfans" ''
      echo 255 | sudo tee /sys/devices/platform/tuxedo_io/fan1_duty
      echo 255 | sudo tee /sys/devices/platform/tuxedo_io/fan2_duty
    '')

    (writeShellScriptBin "autofans" ''
      sudo modprobe -r tuxedo_io && sudo modprobe tuxedo_io
    '')
  ];

  # Set fans to max on boot via systemd
  systemd.services.fan-max = {
    description = "Set fans to maximum speed";
    wantedBy = ["multi-user.target"];
    after = ["systemd-modules-load.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "fan-max" ''
        sleep 5
        echo 255 > /sys/devices/platform/tuxedo_io/fan1_duty
        echo 255 > /sys/devices/platform/tuxedo_io/fan2_duty
      '';
    };
  };
}
