{
  config,
  pkgs,
  ...
}: {
  # ============================================================================
  # TUXEDO DRIVERS (Fan Control)
  # ============================================================================
  hardware.tuxedo-drivers.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.acpi_call];
  boot.kernelModules = ["msr" "tuxedo_io" "tuxedo_keyboard" "ec_sys" "acpi_call"];
  boot.extraModprobeConfig = ''
    options ec_sys write_support=1
  '';

  # ============================================================================
  # UNDERVOLT
  # ============================================================================
  environment.etc."intel-undervolt.conf".text = ''
    undervolt 0 'CPU' -100
    undervolt 1 'GPU' -65
    undervolt 2 'CPU Cache' -50
    undervolt 3 'System Agency' 0
    undervolt 4 'Analog I/O' 0
    power package 60/28 50
  '';

  systemd.services.intel-undervolt = {
    description = "Intel CPU Undervolt";
    wantedBy = ["multi-user.target"];
    after = ["systemd-modules-load.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.intel-undervolt}/bin/intel-undervolt apply";
    };
  };

  environment.systemPackages = with pkgs; [
    intel-undervolt
    lm_sensors
  ];

  # EC register dump (useful for future fan control research)
  # Fan control research findings:
  #   XFAN @ EC offset 0xE7 - fan speed register (BIOS overwrites immediately)
  #   FCMD @ 0xF8, FDAT @ 0xF9, FBUF @ 0xFA - fan command registers
  #   ACPI method \_SB_.WMI_.FEVT - sets fan curve points, not direct speed
  #   EC firmware does not expose Linux fan control for this model

  systemd.services.kbd-backlight = {
    description = "Set keyboard backlight to blue";
    wantedBy = ["multi-user.target"];
    after = ["systemd-modules-load.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "kbd-backlight" ''
        echo "30 80 255" > /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/multi_intensity
        echo 180 > /sys/devices/platform/tuxedo_keyboard/leds/rgb:kbd_backlight/brightness
      '';
    };
  };
}
