{
  nix.gc = {
    automation = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
