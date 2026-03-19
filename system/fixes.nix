# nixos/system/fixes.nix
# System fixes based on journal analysis - March 17, 2026
# Only contains service-level fixes, no packages
{
  config,
  lib,
  pkgs,
  ...
}: {
  # =========================================================================
  # 1. REALTIMEKIT - Fix audio/video realtime priority scheduling
  # Issue: RTKit error: org.freedesktop.DBus.Error.ServiceUnknown
  # =========================================================================
  security.rtkit.enable = true;

  # =========================================================================
  # 2. UPOWER - Enable battery monitoring
  # Issue: Failed to get percentage from UPower: NameHasNoOwner
  # =========================================================================
  services.upower.enable = true;

  # =========================================================================
  # 3. NVIDIA UDEV FIXES - Fix device creation failures
  # Issue: mknod failed for /dev/nvidiactl and GPU devices
  # =========================================================================
  services.udev.extraRules = ''
    # NVIDIA device nodes - fix permissions
    KERNEL=="nvidia[0-9]*", MODE="0666"
    KERNEL=="nvidiactl", MODE="0666"
    KERNEL=="nvidia-uvm", MODE="0666"
    KERNEL=="nvidia-uvm-tools", MODE="0666"
  '';

  # =========================================================================
  # 4. GNOME KEYRING PAM - REMOVED
  # Was causing tuigreet to crash: "greeter exited without creating a session"
  # Greetd already handles keyring via gkr-pam without explicit PAM config
  # =========================================================================

  # =========================================================================
  # 5. TYPEC/I2C FIXES - USB-C DisplayPort and NVIDIA I2C timeout
  # Issue: ucsi_ccg i2c_transfer failed -110, nvidia-gpu i2c timeout error
  # These are hardware-level quirks, DisplayPort may still work
  # =========================================================================
  boot.kernelModules = ["typec"];
  boot.kernelParams = [
    "typec.usb_typec.delay=1000" # Increase timeout for USB-C controller
  ];

  # =========================================================================
  # 6. NETWORK MANAGER - Stability improvements
  # Issue: error setting IPv4 forwarding, supplicant interface init failed
  # =========================================================================
  networking.networkmanager.wifi = {
    powersave = false;
    scanRandMacAddress = false;
  };

  # =========================================================================
  # 7. ACPI - Enable acpid for power management
  # Issue: ACPI warnings about power management
  # =========================================================================
  services.acpid.enable = true;
}
