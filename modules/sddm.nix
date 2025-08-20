{
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
  };
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.theme = {
    name = "pixel_sakura";
  };
}
