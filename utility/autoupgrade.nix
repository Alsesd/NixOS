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
      "--update-input"
      "nixpkgs" # Update nixpkgs
      "--update-input"
      "home-manager" # Update home-manager
      "--commit-lock-file" # Save updated versions
      "-L" # Print build logs (verbose)
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };
}
