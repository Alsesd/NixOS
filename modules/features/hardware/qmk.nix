{
  flake.nixosModules.qmk = {pkgs, ...}: {
    # Enable QMK non-root access module
    hardware.keyboard.qmk.enable = true;

    environment.systemPackages = with pkgs; [
      qmk
      qmk_hid
      via
      vial
    ];

    # Add via & vial packages which supply required udev rules for VIA/Vial devices
    services.udev.packages = with pkgs; [
      qmk-udev-rules
      via
      vial
    ];
  };
}
