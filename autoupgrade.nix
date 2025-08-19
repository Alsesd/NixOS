{
  config,
  pkgs,
  inputs,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--print-build-logs"
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
    allowReboot = false; # Set to true if you want automatic reboots
  };
}
