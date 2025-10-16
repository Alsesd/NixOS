{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ly
  ];

  services.displayManager.ly.enable = true;
}
