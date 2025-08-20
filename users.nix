{
  users.users.alsesd = {
    isNormalUser = true;
    description = "alsesd";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "input"];
    #packages = with pkgs; [];
  };
}
