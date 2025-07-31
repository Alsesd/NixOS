{
  users.users.alsesd = {
    isNormalUser = true;
    description = "alsesd";
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    #packages = with pkgs; [];
  };
}
