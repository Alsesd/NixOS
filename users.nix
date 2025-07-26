{
  users.users.alsesd = {
    isNormalUser = true;
    description = "alsesd";
    extraGroups = ["networkmanager" "wheel"];
    #packages = with pkgs; [];
  };
}
